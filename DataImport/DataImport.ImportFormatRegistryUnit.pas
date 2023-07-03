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
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Generics.Collections, Progress.IProgressUnit, Log.ILoggerUnit,
  System.Threading;

type
  TImportFormatDetectorClass = class of TImportFormatDetector;
  /// <summary>TImportFormatDetector
  /// Детектор формата, определяющий имеют ли данные потока необходимый формат
  /// </summary>
  TImportFormatDetector = class
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

  TImportResultClass = class of TImportResult;
  /// <summary>TImportResult
  /// Результат импорта
  /// </summary>
  TImportResult = class abstract
  end;

  /// <summary>TImportContext
  /// Контекст операци импорта
  /// </summary>
  TImportContext = class
  private
    FImportResult: TImportResult;
    FLogger: ILogger;
    FProgress: IProgress;
  public
    constructor Create(AImportResult: TImportResult; ALogger: ILogger; AProgress:
        IProgress); virtual;
    destructor Destroy; override;
    /// <summary>TImportContext.ImportResult
    /// Объект для загрузки данных
    /// </summary>
    /// type:TImportResult
    property ImportResult: TImportResult read FImportResult;
    /// <summary>TImportContext.Logger
    /// Протокол работы приложения
    /// </summary>
    /// type:ILogger
    property Logger: ILogger read FLogger;
    /// <summary>TImportContext.Progress
    /// Прогресс выполнения операции
    /// </summary>
    /// type:IProgress
    property Progress: IProgress read FProgress;
  end;

  TImportServiceClass = class of TImportService;
  /// <summary>TImportService
  /// Базовый сервис загрузки данных
  /// </summary>
  TImportService = class abstract
  private
    FImportContext: TImportContext;
  public
    constructor Create(AImportContext: TImportContext); virtual;
    /// <summary>TImportService.ImportData
    /// Загрузить данные из потока в объект результатов
    /// </summary>
    procedure ImportData(AStream: TStream; ATask: ITask); virtual; abstract;
    /// <summary>TImportService.ImportContext
    /// Контекст операции импорта
    /// </summary>
    /// type:TImportContext
    property ImportContext: TImportContext read FImportContext;
  end;

  /// <summary>TTypedImportService
  /// Дженерик привязанный к типу результатов импорта
  /// </summary>
  TTypedImportService<T: TImportResult> = class abstract(TImportService)
  private
    function GetImportResult: T;
  public
    /// <summary>TTypedImportService<>.ImportResult
    /// Объект принимающий результаты импорта
    /// </summary>
    /// type:T
    property ImportResult: T read GetImportResult;
  end;

  /// <summary>TImportFormat
  /// Формат импорта - элемент регистра форматов
  /// </summary>
  TImportFormat = class
  private
    FDetectorClass: TImportFormatDetectorClass;
    FDisplayName: String;
    FFileExtensions: TArray<string>;
    FImportResultClass: TImportResultClass;
    FImportServiceClass: TImportServiceClass;
    procedure SetFileExtensions(const Value: TArray<string>);
  public
    /// <summary>TImportFormat.DetectorClass
    /// Класс детектора формата
    /// </summary>
    /// type:TImportFormatDetectorClass
    property DetectorClass: TImportFormatDetectorClass read FDetectorClass;
    /// <summary>TImportFormat.DisplayName
    /// Наименование формата отображаемое в интерфейсе пользователя
    /// </summary>
    /// type:String
    property DisplayName: String read FDisplayName;
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

  /// <summary>TImportFormatRegistry
  /// Регистр форматов импорта
  /// </summary>
  TImportFormatRegistry = class(TDictionary<string, TImportFormat>)
  public
    /// <summary>TImportFormatRegistry.SelectFormatsForFileExtension
    /// Выбрать форматы поддерживающие указанное расширение файлов
    /// </summary>
    /// <param name="AResultFormats"> (TList<TImportFormat>) </param>
    procedure SelectFormatsForFileExtension(AFileExtension: String; AResultFormats:
        TList<TImportFormat>);
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

procedure TImportFormat.SetFileExtensions(const Value: TArray<string>);
begin
  FFileExtensions := Copy(Value);
end;

constructor TImportFormatDetector.Create(AStream: TStream; ALogger: ILogger);
begin
  inherited Create;
  FStream := AStream;
  FLogger := ALogger;
end;

function TTypedImportService<T>.GetImportResult: T;
begin
  Result := FImportContext.FImportResult as T;
end;

constructor TImportContext.Create(AImportResult: TImportResult; ALogger:
    ILogger; AProgress: IProgress);
begin
  inherited Create;
  FImportResult := AImportResult;
  FLogger := ALogger;
  FProgress := AProgress;
end;

destructor TImportContext.Destroy;
begin
  inherited Destroy;
end;

procedure TImportFormatRegistry.SelectFormatsForFileExtension(AFileExtension:
    String; AResultFormats: TList<TImportFormat>);
begin
  for var vFormat in Self.Values do
  begin
    if AnsiIndexText(AFileExtension, vFormat.FileExtensions) >= 0 then
      AResultFormats.Add(vFormat);
  end;
end;

constructor TImportService.Create(AImportContext: TImportContext);
begin
  inherited Create;
  FImportContext := AImportContext;
end;

initialization
  FImportFormatRegistry := TImportFormatRegistry.Create;
finalization
  FImportFormatRegistry.Free;
end.

