unit ExportGui.CsvContextEditorUnitt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ExportGui.BaseContextEditorUnit, System.Actions, Vcl.ActnList, Vcl.StdCtrls,
  DataExport.ExportContextUnit, DataExport.CsvExportContextUnit,
  ExportGui.CodePageContextEditorUnit;

type
  TCsvContextEditor = class(TCodePageContextEditor)
    procedure FormCreate(Sender: TObject);
  strict private
    class var
      FContext: TCsvExportContext;
    procedure LoadContextToControls;
  public
    class function CreateAndEditExportContext: TExportContext; override;
  end;

implementation

uses
  ExportGui.ExportContextFormRegistryUnit;

{$R *.dfm}

procedure TCsvContextEditor.FormCreate(Sender: TObject);
begin
  inherited;
  if FContext = nil then
    FContext := TCsvExportContext.Create;
  LoadContextToControls();
end;

class function TCsvContextEditor.CreateAndEditExportContext: TExportContext;
begin
  Result := nil;
  var vForm := Self.Create(Application);
  try
    if IsPositiveResult(vForm.ShowModal()) then
      Result := FContext;
  finally
    vForm.Free;
  end;
end;

procedure TCsvContextEditor.LoadContextToControls;
begin
  SetCodePage(FContext.CodePage);
end;

initialization
  ExportContextFormRegistry.AddOrSetValue(TCsvExportContext, TCsvContextEditor);

end.

