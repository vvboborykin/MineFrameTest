{*******************************************************
* Project: MineFrameTest
* Unit: DataExport.TxtExportContextUnit.pas
* Description: Контекст экспорта в текстовый файл
*
* Created: 02.07.2023 12:25:47
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.TxtExportContextUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, Data.DB,
  DataImport.MicromineImportService, DataImport.ColumnUnit, DataImport.RowUnit,
  DataExport.ExportContextUnit;

type
  /// <summary>TTxtExportContext
  /// Контекст экспорта в текстовый файл
  /// </summary>
  TTxtExportContext = class(TExportContext)
  private
    FDelimiterChar: Char;
    procedure SetDelimiterChar(const Value: Char);
  public
    constructor Create; override;
    class function FileExtension: String; override;
    /// <summary>TTxtExportContext.DelimiterChar
    /// Разделитель данных CSV файла (по умолчанию символ табуляции #9)
    /// </summary>
    /// type:Char
    property DelimiterChar: Char read FDelimiterChar write SetDelimiterChar;
  end;

implementation

const
  CDefaultDelimiter = '|';


constructor TTxtExportContext.Create;
begin
  inherited Create;
  FDelimiterChar := CDefaultDelimiter;
end;

class function TTxtExportContext.FileExtension: String;
begin
  Result := '.TXT';
end;

procedure TTxtExportContext.SetDelimiterChar(const Value: Char);
begin
  if FDelimiterChar <> Value then
  begin
    FDelimiterChar := Value;
  end;
end;

end.
