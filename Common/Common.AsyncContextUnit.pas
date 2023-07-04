{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.AsyncContextUnit.pas
* Description: Контекст выполнения задачи (в основном или в фоновом потоке)
*
* Created: 04.07.2023 11:35:58
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Common.AsyncContextUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.Threading;

type
  /// <summary>IAsyncContext
  /// Контекст выполнения задачи (в основном или в фоновом потоке)
  /// </summary>
  IAsyncContext = interface
  ['{732F4E48-9EBF-4BA3-B5D6-548804E17DCB}']
    /// <summary>IAsyncContext.Cancel
    /// Прервать выполнение задачи
    /// </summary>
    procedure Cancel; stdcall;
    /// <summary>IAsyncContext.CancellationPengind
    /// Получить состояние флага прерывания задачи
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function CancellationPengind: Boolean; stdcall;
    /// <summary>IAsyncContext.CheckCancelled
    /// Проверить состояние задаму на запрошенное прерывание. Если прерывание
    /// выполненеия задачи запрошено, то выбросить исключение EOperationCancelled
    /// </summary>
    procedure CheckCancelled; stdcall;
  end;

  ITaskAsyncContext = interface(IAsyncContext)
    ['{7358EF1B-D80F-4783-82DE-89FF0338902E}']
    function Task: ITask; stdcall;
  end;

  /// <summary>TTaskAsyncContext
  /// Прокси для ITask
  /// </summary>
  TTaskAsyncContext = class(TInterfacedObject, IAsyncContext, ITaskAsyncContext)
  strict private
    FTask: ITask;
    procedure Cancel; stdcall;
    procedure CheckCancelled; stdcall;
    function CancellationPengind: Boolean; stdcall;
    function Task: ITask; stdcall;
  public
    constructor Create(ATask: ITask);
  end;

  /// <summary>TNullAsyncContext
  /// Пустая заглушка для сихронных операций
  /// </summary>
  TNullAsyncContext = class(TInterfacedObject, IAsyncContext)
  strict private
    procedure Cancel; stdcall;
    procedure CheckCancelled; stdcall;
    function CancellationPengind: Boolean; stdcall;
  end;

implementation

resourcestring
  SATaskAgrumentNotAssigned = 'Не задан аргумент ATask';

constructor TTaskAsyncContext.Create(ATask: ITask);
begin
  if ATask = nil then
    raise EArgumentNilException.Create(SATaskAgrumentNotAssigned);
  inherited Create;
  FTask := ATask;
end;

procedure TTaskAsyncContext.Cancel;
begin
  FTask.Cancel;
end;

function TTaskAsyncContext.CancellationPengind: Boolean;
begin
  Result := FTask.Status = TTaskStatus.Canceled;
end;

procedure TTaskAsyncContext.CheckCancelled;
begin
  FTask.CheckCanceled;
end;

function TTaskAsyncContext.Task: ITask;
begin
  Result := FTask;
end;

procedure TNullAsyncContext.Cancel;
begin
  // none
end;

function TNullAsyncContext.CancellationPengind: Boolean;
begin
  Result := False;
end;

procedure TNullAsyncContext.CheckCancelled;
begin
  // none
end;

end.
