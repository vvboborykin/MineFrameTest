{*******************************************************
* Project: MineFrameTest
* Unit: ExportGui.BaseContextEditorUnit.pas
* Description: Базовая форма редакторы параметров экспорта
*
* Created: 02.07.2023 20:26:46
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit ExportGui.BaseContextEditorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, DataExport.ExportContextUnit;

type
  TBaseContextEditorClass = class of TBaseContextEditor;

  /// <summary>TBaseContextEditor
  /// Базовая форма редакторы параметров экспорта
  /// </summary>
  TBaseContextEditor = class(TForm)
    btnStart: TButton;
    aclMain: TActionList;
    actStart: TAction;
    actCancel: TAction;
    btnCancel: TButton;
    procedure actCancelExecute(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
  private
  public
    /// <summary>TBaseContextEditor.CreateAndEditExportContext
    /// Редактировать параметры экспорта
    /// </summary>
    /// <returns> TExportContext
    /// В случае успешного редактирования - объекта параметров, иначе nil
    /// </returns>
    class function CreateAndEditExportContext: TExportContext; virtual; abstract;
  end;


implementation

{$R *.dfm}

procedure TBaseContextEditor.actCancelExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TBaseContextEditor.actStartExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
