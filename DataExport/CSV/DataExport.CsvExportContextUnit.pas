﻿{*******************************************************
* Project: MineFrameTest
* Unit: DataExport.CsvExportContextUnit.pas
* Description: Контекст данных для экспорта в CSV
*
* Created: 01.07.2023 22:15:26
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.CsvExportContextUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, Data.DB,
  DataImport.MicromineImportService, DataImport.ColumnUnit, DataImport.RowUnit,
  DataExport.ExportContextUnit;

type
  /// <summary>TCsvExportContext
  /// Контекст данных для экспорта в CSV
  /// </summary>
  TCsvExportContext = class(TExportContext)
  private
    FDelimiterChar: Char;
    FQuoteString: Boolean;
    procedure SetDelimiterChar(const Value: Char);
    procedure SetQuoteString(const Value: Boolean);
  public
    constructor Create; override;
    class function FileExtension: String; override;
    /// <summary>TCsvExportContext.DelimiterChar
    /// Разделитель данных CSV файла (по умолчанию символ табуляции #9)
    /// </summary>
    /// type:Char
    property DelimiterChar: Char read FDelimiterChar write SetDelimiterChar;
    /// <summary>TCsvExportContext.QuoteString
    /// Признак необходимости квотирования строк (заключения в двойные кавычки)
    /// </summary>
    /// type:Boolean
    property QuoteString: Boolean read FQuoteString write SetQuoteString;
  end;

implementation

const
  CDefaultDelimiter = #9;

constructor TCsvExportContext.Create;
begin
  inherited Create;
  FDelimiterChar := CDefaultDelimiter;
end;

class function TCsvExportContext.FileExtension: String;
begin
  Result := '.CSV';
end;

procedure TCsvExportContext.SetDelimiterChar(const Value: Char);
begin
  if FDelimiterChar <> Value then
  begin
    FDelimiterChar := Value;
  end;
end;

procedure TCsvExportContext.SetQuoteString(const Value: Boolean);
begin
  if FQuoteString <> Value then
  begin
    FQuoteString := Value;
  end;
end;

end.
