{*******************************************************
* Project: MineFrameTest
* Unit: Export.DataSetToCsvUnit.pas
* Description: Класс службы экспорта в CSV файл
*
* Created: 01.07.2023 21:25:32
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.DataSetToCsvUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, Data.DB,
  MicromineImportService, ColumnUnit, RowUnit,
  DataExport.DataSetExportServiceUnit, DataExport.CsvExportContextUnit;

type
  /// <summary>TDataSetToCsvExportService
  /// Сервис экспорта в CSV
  /// </summary>
  TDataSetToCsvExportService = class(TDataSetExportService)
  private
    function BuildCsvLine(AFunc: TFunc<TField, string>): string;
  protected
    function GetHeader: string; override;
    function GetRecordLine: string; override;
  public
    constructor Create(AContext: TCsvExportContext);
    function CsvContext: TCsvExportContext;
  end;

implementation

uses
  System.IOUtils;

const
  CDefaultDelimiterChar = #9;

constructor TDataSetToCsvExportService.Create(AContext: TCsvExportContext);
begin
  inherited Create(AContext);
end;

function TDataSetToCsvExportService.BuildCsvLine(AFunc: TFunc<TField, string>):
    string;
var
  vDataSet: TDataSet;
begin
  var vLineItems: TArray<string>;

  vDataSet := Context.DataSet;
  for var I := 0 to vDataSet.FieldCount - 1 do
  begin
    var vField := vDataSet.Fields[I];
    var vColNameStr :=  AFunc(vField);

    if CsvContext.QuoteString and (vField is TStringField)  then
      vColNameStr := AnsiQuotedStr(vColNameStr, '"');

    vLineItems := vLineItems + [vColNameStr];
  end;
  Result := ''.Join(CsvContext.DelimiterChar, vLineItems);
end;

function TDataSetToCsvExportService.GetHeader: string;
begin
  Result := BuildCsvLine(
    function(AField: TField): string
    begin
      Result := AField.DisplayLabel
    end);
end;

function TDataSetToCsvExportService.GetRecordLine: string;
begin
  Result := BuildCsvLine(
    function(AField: TField): string
    begin
      Result := AField.AsString;
    end);
end;

function TDataSetToCsvExportService.CsvContext: TCsvExportContext;
begin
  Result := Context as TCsvExportContext;
end;

end.

