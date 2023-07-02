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
  Vcl.ComCtrls, DataImport.MicromineImportService, Data.DB, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, DataImport.ColumnUnit;

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
    FTask: ITask;
    procedure AppendRecordsToTable(AImportService: TMicromineImportService);
    procedure CreateDataFieldDefs(AImportService: TMicromineImportService);
    procedure ExportToFile(vFileName: string);
    function GetFieldSizeOfColumn(vCurrentColumn: TColumn): Integer;
    function GetFieldTypeOfColumn(vCurrentColumn: TColumn): TFieldType;
    procedure ShowPercent(APercent: Double); stdcall;
    procedure ShowText(ATemplate: string; AParams: array of const); stdcall;
    procedure LogString(Sender: TObject; ALogText: string);
    procedure LoadFromMicromineFile(vFileName: TFileName);
    function SelectExportFile: string;
    function SelectMicromineFile(out vFileName: TFileName): Boolean;
    procedure SetFieldDisplayNames(AImportService: TMicromineImportService);
    procedure StartBackgroundImportTask(vFileName: TFileName);
    procedure WaitForImportCancellation;
  private
    procedure LoadImportResultsToTable(AImportService: TMicromineImportService);
  public
    property Logger: ILogger read FLogger implements ILogger;
  end;

var
  MainForm: TMainForm;

implementation

uses
  Log.DelegatedLoggerUnit, DataExport.DataSetExportServiceFactoryUnit,
  DataExport.ExportContextUnit, DataExport.CsvExportContextUnit;

const
  CStrFileExt = '.STR';
  CStrFileOpenDialogFilter = '*' + CStrFileExt + '|*' + CStrFileExt;

resourcestring
  SLoadAbortedByUser = '«агрузка прервана пользователем';
  SCancelLoad = 'ѕрервать загрузку';
  SLoadInProgress = '»дет загрузка данных. „тобы выйти из программы прервите ее';
    {$R *.dfm}

procedure TMainForm.actExportToFileExecute(Sender: TObject);
begin
  var vFileName := SelectExportFile();
  if vFileName <> '' then
    ExportToFile(vFileName);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FLogger := TDelegatedLogger.Create(lolInfo, nil, Self.LogString);
  FLoadBtnCaption := actSelectFileAndLoad.Caption;
end;

procedure TMainForm.actSelectFileAndLoadExecute(Sender: TObject);
var
  vFileName: TFileName;
begin
  if FTask <> nil then
    FTask.Cancel
  else
  begin
    if SelectMicromineFile(vFileName) then
      LoadFromMicromineFile(vFileName);
  end;
end;

procedure TMainForm.AppendRecordsToTable(AImportService: TMicromineImportService);
begin
  for var vCurrentRow in AImportService.Rows do
  begin
    cdsImportResults.Append;
    for var vItem in vCurrentRow do
    begin
      cdsImportResults[vItem.Column.Name] := vItem.Value;
    end;
    cdsImportResults.Post;
  end;
end;

procedure TMainForm.CreateDataFieldDefs(AImportService: TMicromineImportService);
begin
  for var vCurrentColumn in AImportService.Columns do
  begin
    cdsImportResults.FieldDefs.Add(vCurrentColumn.Name, GetFieldTypeOfColumn(vCurrentColumn),
      GetFieldSizeOfColumn(vCurrentColumn));
    var vDef := cdsImportResults.FieldDefs[cdsImportResults.FieldDefs.Count - 1];
    if vCurrentColumn.DataType = cdtDouble then
      vDef.Precision := vCurrentColumn.Precision;
  end;
end;

procedure TMainForm.ExportToFile(vFileName: string);
begin
  var vContext: TExportContext := nil;
  if AnsiSameText(ExtractFileExt(vFileName), '.csv') then
  begin
    vContext := TCsvExportContext.Create();
  end;
  if vContext <> nil then
  begin
    try
      vContext.DataSet := cdsImportResults;
      vContext.FileName := vFileName;
      with TDataSetExportServiceFactory.CreateExportService(vContext) do
      begin
        try
          ExportDataSetToFile();
        finally
          Free;
        end;
      end;
    finally
      vContext.Free;
    end;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // при активной задаче загрузке попросим прервать ее €вно
  CanClose := FTask = nil;
  if not CanClose then
    ShowMessage(SLoadInProgress);
end;

function TMainForm.GetFieldSizeOfColumn(vCurrentColumn: TColumn): Integer;
begin
  Result := 0;
  if vCurrentColumn.DataType = cdtString then
    Result := vCurrentColumn.Len;
end;

function TMainForm.GetFieldTypeOfColumn(vCurrentColumn: TColumn): TFieldType;
begin
  Result := ftString;
  case vCurrentColumn.DataType of
    cdtDouble:
      Result := ftFloat;
    cdtNatural:
      Result := ftInteger;
    cdtString:
      Result := ftString;
  end;
end;

procedure TMainForm.LoadFromMicromineFile(vFileName: TFileName);
begin
  if AnsiSameText(CStrFileExt, ExtractFileExt(vFileName)) then
    StartBackgroundImportTask(vFileName);
end;

procedure TMainForm.LoadImportResultsToTable(AImportService:
  TMicromineImportService);
begin
  cdsImportResults.Close;
  cdsImportResults.FieldDefs.Clear;
  CreateDataFieldDefs(AImportService);
  cdsImportResults.CreateDataSet;
  SetFieldDisplayNames(AImportService);
  AppendRecordsToTable(AImportService);
end;

procedure TMainForm.LogString(Sender: TObject; ALogText: string);
begin
  ShowText(ALogText, []);
end;

function TMainForm.SelectExportFile: string;
begin
  Result := '';
  var vSaveDialog := TSaveDialog.Create(Self);
  try
    vSaveDialog.Filter := '*.CSV|*.CSV|*.TXT|*.TXT';
    if vSaveDialog.Execute then
      Result := vSaveDialog.FileName;
  finally
    vSaveDialog.Free;
  end;
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

procedure TMainForm.SetFieldDisplayNames(AImportService: TMicromineImportService);
begin
  for var I := 0 to cdsImportResults.FieldCount - 1 do
  begin
    var vColumn := AImportService.Columns[I];
    var vDisplayName := VarToStr(vColumn.DisplayName);
    if (vDisplayName <> '') then
      cdsImportResults.Fields[I].DisplayLabel := vDisplayName;
  end;
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

procedure TMainForm.StartBackgroundImportTask(vFileName: TFileName);
begin
  // контекст выполнени€ задачи - журнал, индикатор прогресса
  var vContext := TImportContext.Create(Self, Self, nil);

  // создаем задачу дл€ выполнени€, но пока не запускаем
  FTask := TTask.Create(
    procedure
    begin
      var vImportService := TMicromineImportService.Create(vContext);
      try
        try
          vImportService.ImportFromFile(vFileName);
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
            FTask := nil;
            LoadImportResultsToTable(vImportService);
            actSelectFileAndLoad.Caption := FLoadBtnCaption;
          end);

        vImportService.Free;
        vContext.Free;
      end;
    end);

  // ссылку на задачу поместим в контекст, чтобы служба импорта могла провер€ть
  // запросы на прерывание загрузки от пользовател€
  vContext.Task := FTask;

  actSelectFileAndLoad.Caption := SCancelLoad;
  // стартуем загрузку в фоновой задаче
  FTask.ExecuteWork();
end;

procedure TMainForm.WaitForImportCancellation;
begin
  while FTask <> nil do
  begin
    FTask.Cancel;
    Application.ProcessMessages;
    Sleep(100);
  end;
end;

end.

