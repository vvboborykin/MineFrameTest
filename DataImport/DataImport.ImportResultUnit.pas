{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.ImportResultUnit.pas
* Description: Результат импорта
*
* Created: 03.07.2023 15:14:00
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.ImportResultUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Log.ILoggerUnit;

type
  TImportResultClass = class of TImportResult;

  /// <summary>TImportResult
  /// Результат импорта
  /// </summary>
  TImportResult = class abstract
  end;

implementation

end.
