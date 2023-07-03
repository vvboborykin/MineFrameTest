{*******************************************************
* Project: MineFrameTest
* Unit: MainFormUnit.pas
* Description: √лавна€ форма приложени€
*
* Created: 01.07.2023 18:47:34
* Copyright (C) 2023 Ѕоборыкин ¬.¬. (bpost@yandex.ru)
*******************************************************}
unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Threading, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.StdCtrls,
  Progress.IProgressUnit, Log.ILoggerUnit, System.ImageList, Vcl.ImgList,
  Vcl.ComCtrls, DataImport.Micromine.ImportService, Data.DB, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  DataImport.MicroMine.ColumnUnit;

type
  /// <summary>TMainForm
  ///  √лавна€ форма приложени€
  /// </summary>
  TMainForm = class(TForm, IProgress, ILogger)
    aclMain: TActionList;
    actSelectFileAndLoad: TAction;
    pgcClient: TPageControl;
    tsImport: TTabSheet;
    tsImportResults: TTabSheet;
    ilPages: TImageList;
    btnImport: TButton;
    mmoProgress: TMemo;
    pbProgress: TProgressBar;
    cdsImportResults: TClientDataSet;
    dbgrdLoadResults: TDBGrid;
    dbnvgrGrid: TDBNavigator;
    dsImportResults: TDataSource;
    actExportToFile: TAction;
    btnExport: TButton;
    procedure actExportToFileExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actSelectFileAndLoadExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  strict private
    FLoadBtnCaption: string;
    FLogger: ILogger;
    FImportTask: ITask;
    procedure ShowPercent(APercent: Double); stdcall;
    procedure ShowText(ATemplate: string; AParams: array of const); stdcall;
    procedure LogString(Sender: TObject; ALogText: string);
    procedure LoadFromMicromineFile(vFileName: TFileName);
    function SelectMicromineFile(out vFileName: TFileName): Boolean;
    procedure StartBackgroundImportTask(AFileName: TFileName);
    procedure LoadImportResultsToTable(AImportService: TImportService);
  public
    property Logger: ILogger read FLogger implements ILogger;
  end;

var
  MainForm: TMainForm;

implementation

uses
  Log.DelegatedLoggerUnit, DataExport.ExportServiceFactoryUnit,
  DataExport.ExportContextUnit, DataExport.CsvExportContextUnit,
  ExportGui.ExportFormUnit, DataImport.MicroMine.DataSetBuilderUnit;

resourcestring
  SLoadAbortedByUser = '«агрузка прервана пользователем';
  SCancelLoad = 'ѕрервать загрузку';
  SLoadInProgress = '»дет загрузка данных. „тобы выйти из программы прервите ее';

const
  CStrFileExt = '.STR';
  CStrFileOpenDialogFilter = '*' + CStrFileExt + '|' + '*' + CStrFileExt;

{$R *.dfm}

procedure TMainForm.actExportToFileExecute(Sender: TObject);
begin
  if TExportForm.ExportDataFromDataSet(cdsImportResults) then

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FLogger := TDelegatedLogger.Create(lolInfo, nil, Self.LogString);
  FLoadBtnCaption := actSelectFileAndLoad.Caption;
  pgcClient.ActivePageIndex := 0;
end;

procedure TMainForm.actSelectFileAndLoadExecute(Sender: TObject);
var
  vFileName: TFileName;
begin
  if FImportTask <> nil then
    FImportTask.Cancel
  else
  begin
    if SelectMicromineFile(vFileName) then
      LoadFromMicromineFile(vFileName);
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // при активной задаче загрузки попросим прервать ее €вно
  CanClose := FImportTask = nil;
  if not CanClose then
    ShowMessage(SLoadInProgress);
end;

procedure TMainForm.LoadFromMicromineFile(vFileName: TFileName);
begin
  if AnsiSameText(CStrFileExt, ExtractFileExt(vFileName)) then
    StartBackgroundImportTask(vFileName);
end;

procedure TMainForm.LoadImportResultsToTable(AImportService: TImportService);
begin
  var vBuilder := TDataSetBuilder.Create(AImportService, cdsImportResults);
  try
    vBuilder.BuildDataSetFromImportServiceResults;
  finally
    vBuilder.Free;
  end;
end;

procedure TMainForm.LogString(Sender: TObject; ALogText: string);
begin
  ShowText(ALogText, []);
end;

function TMainForm.SelectMicromineFile(out vFileName: TFileName): Boolean;
begin
  var vOpenDialog := TOpenDialog.Create(Self);
  try
    vOpenDialog.Filter := CStrFileOpenDialogFilter;
    if vOpenDialog.Execute then
      vFileName := vOpenDialog.FileName;
  finally
    vOpenDialog.Free;
  end;
  Result := vFileName <> '';
end;

procedure TMainForm.ShowPercent(APercent: Double);
begin
  // отображение прогресса синхронизируем с основным GUI потоком программы
  TThread.Synchronize(nil,
    procedure
    begin
      if (APercent >= 0) and (APercent <= 100) then
        pbProgress.Position := Trunc(APercent * 100) div 100;
    end);
end;

procedure TMainForm.ShowText(ATemplate: string; AParams: array of const);
begin
  // добавление текста синхронизируем с основным GUI потоком программы
  var vText := Format(ATemplate, AParams);
  TThread.Synchronize(nil,
    procedure
    begin
      mmoProgress.Lines.Insert(0, vText);
    end);
end;

procedure TMainForm.StartBackgroundImportTask(AFileName: TFileName);
begin
  // контекст выполнени€ задачи - журнал, индикатор прогресса
  var vContext := TImportContext.Create(Self, Self, nil);

  // создаем задачу дл€ выполнени€, но пока не запускаем
  FImportTask := TTask.Create(
    procedure
    begin
      var vImportService := TImportService.Create(vContext);
      try
        try
          vImportService.ImportFromFile(AFileName);
        except
          on E: Exception do
          begin
            if E is EOperationCancelled then
              FLogger.LogInfo(SLoadAbortedByUser, [])
            else
              FLogger.LogError(E.Message, []);
          end;
        end;
      finally
        // задача завершена или прервана, обнулим ссылку на нее в форме
        TThread.Synchronize(nil,
          procedure
          begin
            FImportTask := nil;
            LoadImportResultsToTable(vImportService);
            actSelectFileAndLoad.Caption := FLoadBtnCaption;
          end);

        vImportService.Free;
        vContext.Free;
      end;
    end);

  // ссылку на задачу поместим в контекст, чтобы служба импорта могла провер€ть
  // запросы пользовател€ на прерывание процесса загрузки
  vContext.Task := FImportTask;

  actSelectFileAndLoad.Caption := SCancelLoad;
  // стартуем загрузку в фоновой задаче
  FImportTask.ExecuteWork();
end;

end.

