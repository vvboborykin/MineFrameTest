{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.ImportFormatUnit.pas
* Description: Формат импорта - элемент регистра форматов
*
* Created: 03.07.2023 15:05:08
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.ImportFormatUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Log.ILoggerUnit, DataImport.ImportServiceUnit, DataImport.ImportResultUnit,
  DataImport.ImportFormatDetectorUnit;

type
  /// <summary>TImportFormat
  /// Формат импорта - элемент регистра форматов
  /// </summary>
  TImportFormat = class
  private
    FDetectorClass: TImportFormatDetectorClass;
    FDisplayName: string;
    FFileExtensions: TArray<string>;
    FImportResultClass: TImportResultClass;
    FImportServiceClass: TImportServiceClass;
    procedure SetFileExtensions(const Value: TArray<string>);
  public
    /// <summary>TImportFormat.IsValidFormat
    /// Проверить имеет ли поток данных необходимый формат
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="AStream"> (TStream) </param>
    /// <param name="ALogger"> (ILogger) </param>
    function IsValidFormat(AStream: TStream; ALogger: ILogger): Boolean;
    /// <summary>TImportFormat.DetectorClass
    /// Класс детектора формата
    /// </summary>
    /// type:TImportFormatDetectorClass
    property DetectorClass: TImportFormatDetectorClass read FDetectorClass;
    /// <summary>TImportFormat.DisplayName
    /// Наименование формата отображаемое в интерфейсе пользователя
    /// </summary>
    /// type:String
    property DisplayName: string read FDisplayName;
    /// <summary>TImportFormat.FileExtensions
    /// Разрешенные расширения файлов этого формата
    /// </summary>
    /// type:TArray<string>
    property FileExtensions: TArray<string> read FFileExtensions write
      SetFileExtensions;
    /// <summary>TImportFormat.ImportResultClass
    /// Класс результатов импорта
    /// </summary>
    /// type:TImportResultClass
    property ImportResultClass: TImportResultClass read FImportResultClass;
    /// <summary>TImportFormat.ImportServiceClass
    /// Класс сервиса импорта
    /// </summary>
    /// type:TImportServiceClass
    property ImportServiceClass: TImportServiceClass read FImportServiceClass;
  end;

implementation

function TImportFormat.IsValidFormat(AStream: TStream; ALogger: ILogger):
  Boolean;
begin
  var vFormatDetector := DetectorClass.Create(AStream, ALogger);
  try
    Result := vFormatDetector.IsValidFormat;
  finally
    vFormatDetector.Free;
  end;
end;

procedure TImportFormat.SetFileExtensions(const Value: TArray<string>);
begin
  FFileExtensions := Copy(Value);
end;

end.

