{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.AsyncContextUnit.pas
* Description: Контекст выполнения задачи (в основном или в фоновом потоке)
*
* Created: 04.07.2023 11:35:58
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.AsyncContextUnit;

interface

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

implementation

end.
