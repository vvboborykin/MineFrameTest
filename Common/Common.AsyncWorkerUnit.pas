unit Common.AsyncWorkerUnit;

interface

uses
  Common.AsyncContextUnit, Progress.NullProgressUnit, Log.NullLoggerUnit,
  System.Threading, Progress.iprogressunit, Log.iloggerunit, System.SysUtils,
  System.Classes, System.Variants, System.StrUtils;

type
  TAsyncWorker = class abstract
  strict private
    FLogger: ILogger;
    FProgress: IProgress;
    FAfterFinish, FProcessMessages: TProc;
    procedure FillNilPararmeters;
    procedure DoAfterFinish;
    procedure DoProcessMessages;
  strict protected
    /// <summary>TAsyncWorker.ExecureWork
    /// Выполнить операцию в определённом контексте - определить в наследниках
    /// </summary>
    procedure ExecureWork; virtual; abstract;
    procedure ValidateParameters; virtual;
  public
    constructor Create(ALogger: ILogger; AProgress: IProgress); virtual;
    /// <summary>TAsyncWorker<,>.Run
    /// Провести преобразование
    /// </summary>
    procedure Run;
    /// <summary>TAsyncWorker<,>.RunAsync
    /// Запустить преобразование в фоновом вычислительном потоке
    /// </summary>
    /// <returns> ITask
    /// </returns>
    /// <param name="AfterFinish"> (TProc) </param>
    /// <param name="ProcessMessages"> (TProc) </param>
    function RunAsync(AfterFinish, ProcessMessages: TProc): ITask;
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

constructor TAsyncWorker.Create(ALogger: ILogger; AProgress: IProgress);
begin
  inherited Create;
  FLogger := ALogger;
  FProgress := AProgress;
  FillNilPararmeters();
  ValidateParameters();
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
      ExecureWork;
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

procedure TAsyncWorker.ValidateParameters;
begin
  // TODO -cMM: TAsyncWorker.ValidateParameters default body inserted
end;

end.

