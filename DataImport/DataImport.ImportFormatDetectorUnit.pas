{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.ImportFormatDetectorUnit.pas
* Description: Детектор формата, определяющий имеют ли данные потока необходимый формат
*
* Created: 03.07.2023 14:38:47
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.ImportFormatDetectorUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Log.ILoggerUnit;

type
  TImportFormatDetectorClass = class of TImportFormatDetector;

  /// <summary>TImportFormatDetector
  /// Детектор формата, определяющий имеют ли данные потока необходимый формат
  /// </summary>
  TImportFormatDetector = class abstract
  strict private
    FStream: TStream;
    FLogger: ILogger;
  public
    constructor Create(AStream: TStream; ALogger: ILogger);
    /// <summary>TImportFormatDetector.IsValidFormat
    /// Проверить соответствует данные потока формату
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function IsValidFormat: Boolean; virtual; abstract;
    /// <summary>TImportFormatDetector.Logger
    /// Журнал работы приложения
    /// </summary>
    /// type:ILogger
    property Logger: ILogger read FLogger;
    /// <summary>TImportFormatDetector.Stream
    /// Поток для анализа формата
    /// </summary>
    /// type:TStream
    property Stream: TStream read FStream;
  end;

implementation

constructor TImportFormatDetector.Create(AStream: TStream; ALogger: ILogger);
begin
  inherited Create;
  FStream := AStream;
  FLogger := ALogger;
end;

end.

