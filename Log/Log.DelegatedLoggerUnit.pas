{*******************************************************
* Project: MineFrameTest
* Unit: Log.DelegatedLoggerUnit.pas
* Description: Реализация ILogger с передачей функции записи в хранище протокола
*   обработчику события
*
* Created: 01.07.2023 19:09:17
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Log.DelegatedLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Log.ILoggerUnit, Log.BaseLoggerUnit;

type
  // Событие записи данных журнала в хранилище
  TAddLogStringEvent = procedure(Sender: TObject; ALogText: String) of object;

  /// <summary>TDelegatedLogger
  /// Реализация ILogger с передачей функции записи обработчику события
  /// </summary>
  TDelegatedLogger = class(TBaseLogger)
  private
    FOnAddLogString: TAddLogStringEvent;
  strict protected
    procedure DoAddLogString(Sender: TObject; ALogText: String);
    procedure AddLogString(AText: string); override;
  public
    /// <summary>TDelegatedLogger.Create
    /// </summary>
    /// <param name="ASeverity"> (TLogLevel) Минимальная значимость события, которое
    /// необходимо регистировать в журнале</param>
    /// <param name="AFormatFunc"> (TLogRecordFormatFunc) Пользовательский обработчик
    /// форматирования записи (если nil то используется FormatLogRecord)</param>
    /// <param name="AOnAddLogString"> (TAddLogStringEvent) Обработчик записи данных в хранилище </param>
    constructor Create(ASeverity: TLogLevel; AFormatFunc: TLogRecordFormatFunc;
        AOnAddLogString: TAddLogStringEvent);
  end;

implementation

constructor TDelegatedLogger.Create(ASeverity: TLogLevel; AFormatFunc:
    TLogRecordFormatFunc; AOnAddLogString: TAddLogStringEvent);
begin
  inherited Create(ASeverity, AFormatFunc);
  FOnAddLogString := AOnAddLogString;
end;

procedure TDelegatedLogger.AddLogString(AText: string);
begin
  inherited;
  DoAddLogString(Self, AText)
end;

procedure TDelegatedLogger.DoAddLogString(Sender: TObject; ALogText: String);
begin
  if Assigned(FOnAddLogString) then FOnAddLogString(Sender, ALogText);
end;

end.
