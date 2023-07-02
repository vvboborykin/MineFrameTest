{*******************************************************
* Project: MineFrameTest
* Unit: DataExport.TxtExportServiceUnit.pas
* Description: Класс службы экспорта в текстовый файл
*
* Created: 02.07.2023 12:58:19
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.TxtExportServiceUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, Data.DB,
  DataImport.MicromineImportService, DataImport.ColumnUnit, DataImport.RowUnit,
  DataExport.BaseExportServiceUnit, DataExport.CsvExportContextUnit,
  DataExport.TxtExportContextUnit;

type
  /// <summary>TTxtExportService
  /// Класс службы экспорта в текстовый файл
  /// </summary>
  TTxtExportService = class(TBaseExportService<TTxtExportContext>)
  strict private
    function BuildTxtLine(AFunc: TFunc<TField, string>; APadChar: Char = ' ';
        APadMiddle: Boolean = False): string;
    function GetSeparatorLine: string;
    function GetTextColumnSize(vField: TField): Integer;
  strict protected
    function GetHeader: TArray<string>; override;
    function GetRecordLine: string; override;
    function GetFooter: TArray<string>; override;
  end;

implementation

uses
  DataExport.ExportFormatRegistryUnit;

resourcestring
  SExportToTextFile = 'Экспорт в текстовый файл';

function TTxtExportService.BuildTxtLine(AFunc: TFunc<TField, string>; APadChar:
    Char = ' '; APadMiddle: Boolean = False): string;
var
  vColSize: Integer;
  vDataSet: TDataSet;
begin
  var vLineItems: TArray<string>;

  vDataSet := Context.DataSet;
  for var I := 0 to vDataSet.FieldCount - 1 do
  begin
    var vField := vDataSet.Fields[I];
    var vColValueStr :=  AFunc(vField);

    vColSize := GetTextColumnSize(vField);

    if APadMiddle then
    begin
      var vHalfLen :=  (vColSize - vColValueStr.Length) div 2;
      vColValueStr := vColValueStr.PadLeft(vColValueStr.Length + vHalfLen)
        .PadRight(vColSize);
    end
    else
    begin
      if vField is TStringField then
        vColValueStr :=  vColValueStr.PadRight(vColSize, APadChar)
      else
        vColValueStr :=  vColValueStr.PadLeft(vColSize, APadChar);
    end;

    if I = 0 then
      vColValueStr := Context.DelimiterChar + vColValueStr;

    vLineItems := vLineItems + [vColValueStr];
  end;
  Result := ''.Join(Context.DelimiterChar, vLineItems) + Context.DelimiterChar;
end;

function TTxtExportService.GetFooter: TArray<string>;
begin
  Result := [GetSeparatorLine()];
end;

function TTxtExportService.GetHeader: TArray<string>;
begin
  var vSeparatorLine :=  GetSeparatorLine();

  var vHeadLine := BuildTxtLine(
    function(AField: TField): string
    begin
      Result := AField.DisplayLabel
    end, ' ', True);

  Result := [vSeparatorLine, vHeadLine, vSeparatorLine];
end;

function TTxtExportService.GetRecordLine: string;
begin
  Result := BuildTxtLine(
    function(AField: TField): string
    begin
      Result := AField.AsString;
    end);
end;

function TTxtExportService.GetSeparatorLine: string;
begin
  Result := BuildTxtLine(
    function(AField: TField): string
    begin
      Result := '-';
    end, '-');
end;

function TTxtExportService.GetTextColumnSize(vField: TField): Integer;
begin
  var vTextlen: Integer;
  if vField is TFloatField then
    vTextlen := 25
  else
  if vField is TIntegerField then
    vTextlen := 25
  else
  if vField is TStringField then
    vTextlen := vField.Size
  else
    vTextlen := 50;

  if vTextlen < vField.DisplayLabel.Length then
    vTextlen := vField.DisplayLabel.Length;
  Result := vTextlen;
end;

initialization
  ExportFormatRegistry.Add(TExportFormat.Create(TTxtExportContext,
    TTxtExportService, SExportToTextFile));

end.
