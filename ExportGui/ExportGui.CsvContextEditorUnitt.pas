{*******************************************************
* Project: MineFrameTest
* Unit: ExportGui.CsvContextEditorUnitt.pas
* Description: Редактор параметров экспорта в CSV
*
* Created: 02.07.2023 14:15:44
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit ExportGui.CsvContextEditorUnitt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.UITypes, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, ExportGui.BaseContextEditorUnit, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, DataExport.ExportContextUnit, DataExport.CsvExportContextUnit,
  System.RegularExpressions, ExportGui.CodePageContextEditorUnit, Vcl.Mask;

type
  /// <summary>TCsvContextEditor
  /// Редактор параметров экспорта в CSV
  /// </summary>
  TCsvContextEditor = class(TCodePageContextEditor)
    chkQuote: TCheckBox;
    grpDelimiterType: TGroupBox;
    rbSeicolon: TRadioButton;
    rbComma: TRadioButton;
    rbTab: TRadioButton;
    rbCustomDelim: TRadioButton;
    medtDelimiter: TMaskEdit;
    procedure actStartExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  strict private
    class var
      FContext: TCsvExportContext;
    var
    function GetDelimiterChar: Char;
    procedure LoadContextToControls;
    procedure SaveContorlsToContext;
    procedure SetQuotation(AQuotation: Boolean);
  strict protected
    procedure SetDelimiter(DelimiterChar: Char);
  public
    class function CreateAndEditExportContext: TExportContext; override;
  end;

implementation

uses
  ExportGui.ExportContextFormRegistryUnit;

resourcestring
  SInvalidDelimStringFormat =
    'Неверный формат строки предопределенного разделителя';

{$R *.dfm}

procedure TCsvContextEditor.actStartExecute(Sender: TObject);
begin
  inherited;
  SaveContorlsToContext();
end;

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

function TCsvContextEditor.GetDelimiterChar: Char;
begin
  if rbTab.Checked then
    Result := #9
  else if rbSeicolon.Checked then
    Result := ';'
  else if rbComma.Checked then
    Result := ','
  else
    Result := medtDelimiter.Text[1];
end;

procedure TCsvContextEditor.LoadContextToControls;
begin
  SetCodePage(FContext.CodePage);
  SetDelimiter(FContext.DelimiterChar);
  SetQuotation(FContext.QuoteString);
end;

procedure TCsvContextEditor.SaveContorlsToContext;
begin
  FContext.QuoteString := chkQuote.Checked;
  FContext.DelimiterChar := GetDelimiterChar();
  FContext.CodePage := GetSelectedCodePage();
  FContext.QuoteString := chkQuote.Checked;
end;

procedure TCsvContextEditor.SetDelimiter(DelimiterChar: Char);
begin
  case DelimiterChar of
    #9:
      rbTab.Checked := True;
    ',':
      rbComma.Checked := True;
    ';':
      rbSeicolon.Checked := True;
  else
    rbCustomDelim.Checked := True;
    medtDelimiter.Text := DelimiterChar;
  end;
end;

procedure TCsvContextEditor.SetQuotation(AQuotation: Boolean);
begin
  chkQuote.Checked := AQuotation;
end;

initialization
  ExportContextFormRegistry.AddOrSetValue(TCsvExportContext, TCsvContextEditor);

end.

