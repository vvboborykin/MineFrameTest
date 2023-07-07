{*******************************************************
* Project: MineFrameTest
* Unit: Common.AsyncWorkerUnit.pas
* Description: Базовый класс для объектов исполняющих заданную операцию
*  в фоновом вычислительном потоке
*  или в основном вычислительном потоке
*
* Created: 04.07.2023 22:55:26
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Common.AsyncWorkerUnit;

interface

uses
  Common.AsyncContextUnit, Progress.NullProgressUnit, Log.NullLoggerUnit,
  System.Threading, Progress.iprogressunit, Log.iloggerunit, System.SysUtils,
  System.Classes, System.Variants, System.StrUtils;

type
  TAsyncWorkerClass = class of TAsyncWorker;

  /// <summary>TAsyncWorker
  /// Базовый класс для объектов исполняющих заданную операцию
  /// в фоновом вычислительном потоке
  /// или в основном вычислительном потоке
  /// </summary>
  TAsyncWorker = class abstract
  strict private
    FContext: TObject;
    FLogger: ILogger;
    FProgress: IProgress;
    FAfterFinish, FProcessMessages: TProc;
    procedure FillNilPararmeters;
    procedure DoAfterFinish;
    procedure InternalRun;
  strict protected
    /// <summary>TAsyncWorker.ExecureWork
    /// Метод выполняющий операцию - переопределить в наследниках
    /// </summary>
    procedure ExecureWork; virtual; abstract;
    procedure DoProcessMessages;
  public
    constructor Create(ALogger: ILogger; AProgress: IProgress; AContext: TObject);
    /// <summary>TAsyncWorker<,>.Run
    /// Выполнить операцию в основном вычислительном потоке
    /// </summary>
    procedure Run;
    /// <summary>TAsyncWorker<,>.RunAsync
    /// Запустить выполнение операции в фоновом вычислительном потоке
    /// </summary>
    /// <returns> ITask
    /// </returns>
    /// <param name="AfterFinish"> (TProc) Процедура вызываемая
    /// по окончанию выполнения операции</param>
    /// <param name="ProcessMessages"> (TProc) Процедура обработки
    /// очереди сообщений (для предотвращения зависания GUI)</param>
    function RunAsync(AfterFinish, ProcessMessages: TProc): ITask;
    /// <summary>TAsyncWorker.Context
    /// Пользовательский контекст выполнения операции
    /// </summary>
    /// type:TObject
    property Context: TObject read FContext;
    /// <summary>TAsyncWorker<,>.Logger
    /// Журнал работы приложения
    /// </summary>
    /// type:ILogger
    property Logger: ILogger read FLogger;
    /// <summary>TAsyncWorker<,>.Progress
    /// Индикатор выполнения преобразования
    /// </summary>
    /// type:IProgress
    property Progress: IProgress read FProgress;
  end;

implementation

resourcestring
  SConvertionAborted = 'Преобразование прервано';


constructor TAsyncWorker.Create(ALogger: ILogger; AProgress: IProgress;
    AContext: TObject);
begin
  inherited Create;
  FLogger := ALogger;
  FProgress := AProgress;
  FContext := AContext;
  FillNilPararmeters();
end;

procedure TAsyncWorker.Run;
begin
  FAfterFinish := nil;
  FProcessMessages := nil;
  ExecureWork;
end;

function TAsyncWorker.RunAsync(AfterFinish, ProcessMessages: TProc): ITask;
var
  AsyncContext: ITaskAsyncContext;
begin
  FAfterFinish := AfterFinish;
  FProcessMessages := ProcessMessages;
  AsyncContext := TTaskAsyncContext.Create(TTask.Create(
    procedure
    begin
      InternalRun();
    end));
  Result := AsyncContext.Task;
  Result.ExecuteWork;
end;

procedure TAsyncWorker.DoAfterFinish;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if Assigned(FAfterFinish) then
        FAfterFinish;
    end);
end;

procedure TAsyncWorker.DoProcessMessages;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if Assigned(FProcessMessages) then
        FProcessMessages;
    end);
end;

procedure TAsyncWorker.FillNilPararmeters;
begin
  if FLogger = nil then
    FLogger := TNullLogger.Create(lolInfo, nil);
  if FProgress = nil then
    FProgress := TNullProgress.Create;
end;

procedure TAsyncWorker.InternalRun;
begin
  try
    try
      ExecureWork;
    finally
      DoAfterFinish;
    end;
  except
    on E: Exception do
    begin
    if E is EOperationCancelled then
      Logger.LogInfo(SConvertionAborted, [])
    else
      Logger.LogError(E.Message, []);
    end;
  end;
end;

end.

