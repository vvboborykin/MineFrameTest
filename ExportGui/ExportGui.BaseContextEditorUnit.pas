unit ExportGui.BaseContextEditorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, DataExport.ExportContextUnit;

type
  TBaseContextEditorClass = class of TBaseContextEditor;

  TBaseContextEditor = class(TForm)
    btnStart: TButton;
    aclMain: TActionList;
    actStart: TAction;
    procedure actStartExecute(Sender: TObject);
  private
  public
    class function CreateAndEditExportContext: TExportContext; virtual; abstract;
  end;


implementation

{$R *.dfm}

procedure TBaseContextEditor.actStartExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
