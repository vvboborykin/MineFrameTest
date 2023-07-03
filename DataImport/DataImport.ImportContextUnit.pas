{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.ImportContextUnit.pas
* Description: Контекст операции импорта данных
*
* Created: 03.07.2023 15:03:29
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.ImportContextUnit;

interface

uses
  Progress.IProgressUnit, Log.ILoggerUnit, DataImport.ImportResultUnit;

type
  /// <summary>TImportContext
  /// Контекст операции импорта данных
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

implementation

constructor TImportContext.Create(AImportResult: TImportResult; ALogger: ILogger;
  AProgress: IProgress);
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

end.

