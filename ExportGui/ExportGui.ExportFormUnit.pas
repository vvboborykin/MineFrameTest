unit ExportGui.ExportFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TExportForm = class(TForm)
    aclMain: TActionList;
    btnStart: TButton;
    actStart: TAction;
    rgFormats: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
    procedure actStartUpdate(Sender: TObject);
  strict private
    procedure FillFormatsRadioGroup;
    procedure SelectDefaultFormat;
    procedure StartExport;
  private
    { Private declarations }
  public
    /// <summary>TExportForm.ExportDataFromDataSet
    /// Экспортировать данные набора данных
    /// </summary>
    /// <param name="ADataSet"> (TDataSet) </param>
    class procedure ExportDataFromDataSet(ADataSet: TDataSet);
  end;

implementation

uses
  DataExport.ExportFormatRegistryUnit;

{$R *.dfm}

procedure TExportForm.FormCreate(Sender: TObject);
begin
  FillFormatsRadioGroup();
  SelectDefaultFormat();
end;

procedure TExportForm.actStartExecute(Sender: TObject);
begin
  StartExport();
end;

procedure TExportForm.actStartUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := rgFormats.ItemIndex >= 0;
end;

class procedure TExportForm.ExportDataFromDataSet(ADataSet: TDataSet);
begin
  // TODO -cMM: TExportForm.ExportDataFromDataSet default body inserted
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

procedure TExportForm.StartExport;
begin
  // TODO -cMM: TExportForm.StartExport default body inserted
end;

end.
