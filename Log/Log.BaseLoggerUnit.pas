{*******************************************************
* Project: MineFrameTest
* Unit: Log.BaseLoggerUnit.pas
* Description: Базовая абстрактная реализация ILogger
*
* Created: 01.07.2023 19:03:08
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Log.BaseLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Log.ILoggerUnit;

type
  // Событие форматирования строки для записи журнала
  TLogRecordFormatFunc = reference to function(ALevel: TLogLevel; ATemplate:
    string; AParams: array of const): string;

  /// <summary>TBaseLogger
  /// Базовая абстрактная реализация ILogger
  /// </summary>
  TBaseLogger = class abstract(TInterfacedObject, ILogger)
  strict private
    FSeverity: TLogLevel;
    procedure LogDebug(ATemplate: string; AParams: array of const); stdcall;
    procedure LogError(ATemplate: string; AParams: array of const); stdcall;
    procedure LogInfo(ATemplate: string; AParams: array of const); stdcall;
    procedure LogString(ALevel: TLogLevel; ATemplate: string; AParams: array of
      const); stdcall;
    procedure LogWarning(ATemplate: string; AParams: array of const); stdcall;
    procedure SetSeverity(const Value: TLogLevel);
  strict protected
    FFormatFunc: TLogRecordFormatFunc;
    procedure AddLogString(AText: string); virtual; abstract;
    /// <summary>TBaseLogger.FormatLogRecord
    /// Метод формирования записи журнала по умолчанию
    /// </summary>
    /// <returns> string
    /// </returns>
    /// <param name="ALevel"> (TLogLevel) </param>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    function FormatLogRecord(ALevel: TLogLevel; ATemplate: string; AParams:
      array of const): string; virtual;
  public
    /// <summary>TBaseLogger.Create
    /// </summary>
    /// <param name="ASeverity"> (TLogLevel) Минимальная значимость события, которое
    /// необходимо регистировать в журнале</param>
    /// <param name="AFormatFunc"> (TLogRecordFormatFunc) Пользовательский обработчик
    /// форматирования записи (если nil то используется FormatLogRecord)</param>
    constructor Create(ASeverity: TLogLevel; AFormatFunc: TLogRecordFormatFunc);
      /// <summary>TBaseLogger.GetLogLevelName
    /// Получить строковое представление значимости события
    /// </summary>
    /// <returns> string
    /// </returns>
    /// <param name="ALevel"> (TLogLevel) Значимость</param>
    class function GetLogLevelName(ALevel: TLogLevel): string;
    /// <summary>TBaseLogger.Severity
    /// Минимальная значимость события, которое необходимо регистировать в журнале
    /// </summary>
    /// type:TLogLevel
    property Severity: TLogLevel read FSeverity write SetSeverity;
  end;

implementation

resourcestring
  SDebugLogLevelName = 'Отладка';
  SInfoLogLevelName = 'Информация';
  SWarningLogLevelName = 'Предупреждение';
  SErrorLogLevelName = 'ОШИБКА';

const
  CLogLevelNames: array[Low(TLogLevel)..High(TLogLevel)] of string =
    (SDebugLogLevelName, SInfoLogLevelName, SWarningLogLevelName,
      SErrorLogLevelName);

constructor TBaseLogger.Create(ASeverity: TLogLevel; AFormatFunc:
  TLogRecordFormatFunc);
begin
  inherited Create;
  FSeverity := ASeverity;
  FFormatFunc := AFormatFunc;
end;

function TBaseLogger.FormatLogRecord(ALevel: TLogLevel; ATemplate: string;
  AParams: array of const): string;
var
  vText: string;
begin
  if Assigned(FFormatFunc) then
    Result := FFormatFunc(ALevel, ATemplate, AParams)
  else
  begin
    vText := Format(ATemplate, AParams);
    Result := Format('%s'#9'%s'#9'%s', [DateTimeToStr(Now), GetLogLevelName(ALevel),
      vText]);
  end;
end;

class function TBaseLogger.GetLogLevelName(ALevel: TLogLevel): string;
begin
  Result := CLogLevelNames[ALevel];
end;

procedure TBaseLogger.LogDebug(ATemplate: string; AParams: array of const);
begin
  LogString(lolDebug, ATemplate, AParams)
end;

procedure TBaseLogger.LogError(ATemplate: string; AParams: array of const);
begin
  LogString(lolError, ATemplate, AParams)
end;

procedure TBaseLogger.LogInfo(ATemplate: string; AParams: array of const);
begin
  LogString(lolInfo, ATemplate, AParams)
end;

procedure TBaseLogger.LogString(ALevel: TLogLevel; ATemplate: string; AParams:
  array of const);
begin
  if ALevel >= Severity then
    AddLogString(FormatLogRecord(ALevel, ATemplate, AParams));
end;

procedure TBaseLogger.LogWarning(ATemplate: string; AParams: array of const);
begin
  LogString(lolWarning, ATemplate, AParams)
end;

procedure TBaseLogger.SetSeverity(const Value: TLogLevel);
begin
  FSeverity := Value;
end;

end.

