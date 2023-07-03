{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.ImportServiceUnit.pas
* Description: Базовый сервис импорта данных
*
* Created: 03.07.2023 15:03:12
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.ImportServiceUnit;

interface

uses
  System.Threading, System.Classes, DataImport.ImportContextUnit,
  DataImport.ImportResultUnit;

type
  TImportServiceClass = class of TImportService;
  /// <summary>TImportService
  /// Базовый сервис импорта данных
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
  /// Дженерик сервиса импорта данных привязанный к типу результатов импорта
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

implementation

function TTypedImportService<T>.GetImportResult: T;
begin
  Result := FImportContext.ImportResult as T;
end;

constructor TImportService.Create(AImportContext: TImportContext);
begin
  inherited Create;
  FImportContext := AImportContext;
end;

end.

