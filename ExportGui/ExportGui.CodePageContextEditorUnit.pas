{*******************************************************
* Project: MineFrameTest
* Unit: ExportGui.CodePageContextEditorUnit.pas
* Description: Базовая форма редактора параметров экспорта с указанием кодовой станицы
*
* Created: 02.07.2023 14:01:47
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit ExportGui.CodePageContextEditorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils,
  System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, ExportGui.BaseContextEditorUnit, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls;

type
  /// <summary>TCodePageContextEditor
  /// Базовая форма редактора параметров экспорта с указанием кодовой станицы
  /// </summary>
  TCodePageContextEditor = class(TBaseContextEditor)
    cbbCodePage: TComboBox;
    lblCodePage: TLabel;
  private
  strict protected
    /// <summary>TCodePageContextEditor.GetSelectedCodePage
    /// Получить выбранную кодовую страницу
    /// </summary>
    /// <returns> Integer
    /// </returns>
    function GetSelectedCodePage: Integer;
    procedure SetCodePage(ACodePage: Integer);
  public
  end;

implementation

{$R *.dfm}

function TCodePageContextEditor.GetSelectedCodePage: Integer;
begin
  var vParts := cbbCodePage.Items[cbbCodePage.ItemIndex].Split([' ']);
  Result := vParts[0].ToInteger();
end;

procedure TCodePageContextEditor.SetCodePage(ACodePage: Integer);
begin
  var vIndex := -1;
  for var I := 0 to cbbCodePage.Items.Count-1 do
  begin
    var vText := cbbCodePage.Items[I];
    if AnsiStartsText(ACodePage.ToString + ' ', vText) then
    begin
      vIndex := I;
      Break;
    end;
  end;
  cbbCodePage.ItemIndex := vIndex;
end;

end.

