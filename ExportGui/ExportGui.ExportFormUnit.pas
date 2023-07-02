unit ExportGui.ExportFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.UITypes, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Data.DB, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.ExtCtrls,
  DataExport.ExportContextUnit;

type
  TExportForm = class(TForm)
    aclMain: TActionList;
    btnStart: TButton;
    actStart: TAction;
    rgFormats: TRadioGroup;
    actCancel: TAction;
    btnCancel: TButton;
    procedure actCancelExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
    procedure actStartUpdate(Sender: TObject);
  strict private
    FDataSet: TDataSet;
    procedure FillFormatsRadioGroup;
    procedure SelectDefaultFormat;
    procedure DoExport;
    function GetSelectedExportContext(out AExportContext: TExportContext):
      Boolean;
    function SelectExportFileName(AExportContext: TExportContext): Boolean;
  public
    /// <summary>TExportForm.ExportDataFromDataSet
    /// Экспортировать данные набора данных
    /// </summary>
    /// <param name="ADataSet"> (TDataSet) </param>
    class function ExportDataFromDataSet(ADataSet: TDataSet): Boolean;
  end;

implementation

uses
  DataExport.ExportFormatRegistryUnit, DataExport.ExportServiceFactoryUnit,
  ExportGui.BaseContextEditorUnit, ExportGui.ExportContextFormRegistryUnit;

{$R *.dfm}

resourcestring
  SExportCompletedSuccessfully = 'Экспорт данных успашно завершен';

procedure TExportForm.actCancelExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TExportForm.FormCreate(Sender: TObject);
begin
  FillFormatsRadioGroup();
  SelectDefaultFormat();
end;

procedure TExportForm.actStartExecute(Sender: TObject);
begin
  DoExport();
end;

procedure TExportForm.actStartUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := rgFormats.ItemIndex >= 0;
end;

class function TExportForm.ExportDataFromDataSet(ADataSet: TDataSet): Boolean;
begin
  var vExportForm := TExportForm.Create(Application);
  vExportForm.FDataSet := ADataSet;
  try
    Result := IsPositiveResult(vExportForm.ShowModal);
  finally
    vExportForm.Free;
  end;
end;

procedure TExportForm.FillFormatsRadioGroup;
begin
  rgFormats.Items.Clear;
  for var vFormat in ExportFormatRegistry do
    rgFormats.Items.AddObject(vFormat.DisplayName, vFormat);
end;

procedure TExportForm.SelectDefaultFormat;
begin
  rgFormats.ItemIndex := 0;
end;

procedure TExportForm.DoExport;
begin
  var vExportContext: TExportContext;
  if GetSelectedExportContext(vExportContext) then
  begin
    vExportContext.DataSet := FDataSet;
    if SelectExportFileName(vExportContext) then
    begin
      var vExportService := TDataSetExportServiceFactory.CreateExportService(vExportContext);
      try
        vExportService.ExportDataSetToFile();
        ShowMessage(SExportCompletedSuccessfully);
      except
        on E: Exception do
          MessageDlg(Format('Ошибка при экспорте %s', [E.Message]), TMsgDlgType.mtError,
            [TMsgDlgBtn.mbOK], 0);
      end;
    end;
  end;
end;

function TExportForm.GetSelectedExportContext(out AExportContext: TExportContext):
  Boolean;
begin
  var vSelectedFormat := TExportFormat(rgFormats.Items.Objects[rgFormats.ItemIndex]);
  var vContextClass := vSelectedFormat.ContextClass;
  var vEditorClass: TBaseContextEditorClass;
  var vExportContext: TExportContext;

  if ExportContextFormRegistry.TryGetValue(vContextClass, vEditorClass) then
  begin
    vExportContext := vEditorClass.CreateAndEditExportContext();
    Result := vExportContext <> nil;
  end
  else
  begin
    vExportContext := vContextClass.Create;
    Result := True;
  end;
  AExportContext := vExportContext;
end;

function TExportForm.SelectExportFileName(AExportContext: TExportContext):
  Boolean;
begin
  var vSaveDialog := TSaveDialog.Create(Self);
  try
    var vExt := '*' + AExportContext.FileExtension;
    vSaveDialog.Filter := vExt + '|' + vExt;
    vSaveDialog.DefaultExt := vExt;
    Result := vSaveDialog.Execute;
    if Result then
      AExportContext.FileName := vSaveDialog.FileName;
  finally
    vSaveDialog.Free;
  end;
end;

end.

