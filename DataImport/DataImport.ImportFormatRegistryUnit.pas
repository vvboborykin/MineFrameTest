{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.ImportFormatRegistryUnit.pas
* Description: Регистр форматов импортв
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
  /// Детектор формата, определяющий имеют ли данные потока указанный формат
  /// </summary>
  TImportFormatDetector = class
  strict private
    FStream: TStream;
  public
    constructor Create(AStream: TStream);
    function IsValidFormat: Boolean; virtual; abstract;
    property Stream: TStream read FStream;
  end;

  TImportResultClass = class of TImportResult;
  /// <summary>TImportResult
  /// Результат импорта
  /// </summary>
  TImportResult = class abstract
  end;

  /// <summary>TImportContext
  /// Контекст импорта
  /// </summary>
  TImportContext = class
  private
    FImportResult: TImportResult;
    FLogger: ILogger;
    FProgress: IProgress;
    FSourceStream: TStream;
    FTask: ITask;
  public
    constructor Create(AImportResult: TImportResult; ALogger: ILogger; AProgress:
        IProgress; ASourceStream: TStream; ATask: ITask); virtual;
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
    /// <summary>TImportContext.SourceStream
    /// Поток с импортируемыми данными
    /// </summary>
    /// type:TStream
    property SourceStream: TStream read FSourceStream;
    /// <summary>TImportContext.Task
    /// Фоновая задача, в рамках которой выполняется операция
    /// </summary>
    /// type:ITask
    property Task: ITask read FTask;
  end;

  TImportServiceClass = class of TImportService;

  /// <summary>TImportService
  /// Базовый сервис загрузки данных
  /// </summary>
  TImportService = class abstract
  private
    FImportContext: TImportContext;
  public
    /// <summary>TImportService.ImportData
    /// Загрузить данные из потока в объект результатов
    /// </summary>
    procedure ImportData; virtual; abstract;
    property ImportContext: TImportContext read FImportContext;
  end;

  TTypedImportService<T: TImportResult> = class abstract(TImportService)
  private
    function GetImportResult: T;
  public
    property ImportResult: T read GetImportResult;
  end;

  /// <summary>TImportFormat
  /// Формат импорта
  /// </summary>
  TImportFormat = class
  private
    FDetectorClass: TImportFormatDetectorClass;
    FFileExtensions: TArray<string>;
    FImportResultClass: TImportResultClass;
    procedure SetFileExtensions(const Value: TArray<string>);
  public
    /// <summary>TImportFormat.DetectorClass
    /// Класс детектора формата
    /// </summary>
    /// type:TImportFormatDetectorClass
    property DetectorClass: TImportFormatDetectorClass read FDetectorClass;
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
  end;

  /// <summary>TImportFormatRegistry
  /// Регистр форматов импортв
  /// </summary>
  TImportFormatRegistry = class(TObjectList<TImportFormat>)
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

constructor TImportFormatDetector.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;
end;

function TTypedImportService<T>.GetImportResult: T;
begin
  Result := FImportContext.FImportResult as T;
end;

constructor TImportContext.Create(AImportResult: TImportResult; ALogger:
    ILogger; AProgress: IProgress; ASourceStream: TStream; ATask: ITask);
begin
  inherited Create;
  FImportResult := AImportResult;
  FLogger := ALogger;
  FProgress := AProgress;
  FSourceStream := ASourceStream;
  FTask := ATask;
end;

destructor TImportContext.Destroy;
begin
  inherited Destroy;
end;

initialization
  FImportFormatRegistry := TImportFormatRegistry.Create;
finalization
  FImportFormatRegistry.Free;
end.

