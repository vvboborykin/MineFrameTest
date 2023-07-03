{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.ImportFormatRegistryUnit.pas
* Description: Регистр форматов импорта
*
* Created: 02.07.2023 23:06:14
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.ImportFormatRegistryUnit;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  DataImport.ImportServiceUnit, DataImport.ImportContextUnit, System.Variants,
  System.StrUtils, Generics.Collections, Progress.IProgressUnit, Log.ILoggerUnit,
  System.Threading, DataImport.ImportFormatDetectorUnit,
  DataImport.ImportFormatUnit, DataImport.ImportResultUnit;

type
  /// <summary>TImportFormatRegistry
  /// Регистр форматов импорта
  /// </summary>
  TImportFormatRegistry = class(TDictionary<System.string, TImportFormat>)
  public
    /// <summary>TImportFormatRegistry.SelectFormatsForFileExtension
    /// Выбрать форматы поддерживающие указанное расширение файлов
    /// </summary>
    /// <param name="AResultFormats"> (TList<TImportFormat>) </param>
    procedure SelectFormatsForFileExtension(AFileExtension: string;
      AResultFormats: TList<TImportFormat>);
  end;

  /// Синглтон регистра
function ImportFormatRegistry: TImportFormatRegistry;

implementation

var
  FImportFormatRegistry: TImportFormatRegistry;

function ImportFormatRegistry: TImportFormatRegistry;
begin
  Result := FImportFormatRegistry;
end;

procedure TImportFormatRegistry.SelectFormatsForFileExtension(AFileExtension:
  string; AResultFormats: TList<TImportFormat>);
begin
  for var vFormat in Self.Values do
  begin
    if AnsiIndexText(AFileExtension, vFormat.FileExtensions) >= 0 then
      AResultFormats.Add(vFormat);
  end;
end;

initialization
  FImportFormatRegistry := TImportFormatRegistry.Create;

finalization
  FImportFormatRegistry.Free;

end.

