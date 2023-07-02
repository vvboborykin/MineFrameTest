{*******************************************************
* Project: MineFrameTest
* Unit: Export.DataSetToCsvUnit.pas
* Description: Класс службы экспорта в CSV файл
*
* Created: 01.07.2023 21:25:32
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.CsvExportServiceUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, Data.DB,
  DataImport.MicromineImportService, DataImport.ColumnUnit, DataImport.RowUnit,
  DataExport.CsvExportContextUnit, DataExport.BaseExportServiceUnit;

type
  /// <summary>TCsvExportService
  /// Сервис экспорта в CSV
  /// </summary>
  TCsvExportService = class(TBaseExportService<TCsvExportContext>)
  private
    function BuildCsvLine(AFunc: TFunc<TField, string>): string;
  protected
    function GetHeader: TArray<string>; override;
    function GetRecordLine: string; override;
  public
  end;

implementation

uses
  System.IOUtils, DataExport.ExportFormatRegistryUnit;

resourcestring
  SExpotrToCsvFile = 'Экспорт в файл CSV';

const
  CDefaultDelimiterChar = #9;

function TCsvExportService.BuildCsvLine(AFunc: TFunc<TField, string>):
    string;
var
  vDataSet: TDataSet;
begin
  var vLineItems: TArray<string>;

  vDataSet := Context.DataSet;
  for var I := 0 to vDataSet.FieldCount - 1 do
  begin
    var vField := vDataSet.Fields[I];
    var vColNameStr := AFunc(vField);

    if Context.QuoteString and (vField is TStringField)  then
      vColNameStr := AnsiQuotedStr(vColNameStr, '"');

    vLineItems := vLineItems + [vColNameStr];
  end;
  Result := ''.Join(Context.DelimiterChar, vLineItems);
end;

function TCsvExportService.GetHeader: TArray<string>;
begin
  Result := [BuildCsvLine(
    function(AField: TField): string
    begin
      Result := AField.DisplayLabel;
    end)];
end;

function TCsvExportService.GetRecordLine: string;
begin
  Result := BuildCsvLine(
    function(AField: TField): string
    begin
      Result := AField.AsString;
    end);
end;

initialization
  ExportFormatRegistry.Add(TExportFormat.Create(TCsvExportContext,
    TCsvExportService, SExpotrToCsvFile));
end.

