{*******************************************************
* Project: MineFrameTest
* Unit: Log.ILoggerUnit.pas
* Description: Декларация интерфейса журнала работы приложения
*
* Created: 01.07.2023 18:58:55
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Log.ILoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils;

type
  // Уровень значимости события журнала
  TLogLevel = (lolDebug, lolInfo, lolWarning, lolError);

  /// <summary>ILogger
  /// Интерфейс журнала работы приложения
  /// </summary>
  ILogger = interface
    ['{394FB66C-73E8-4C9D-8A9E-BD07E4DADF03}']
    /// <summary>ILogger.LogString
    /// Зарегистрировать в журнале текстовую запись
    /// </summary>
    /// <param name="ALevel"> (TLogLevel) Уровень значимости записи</param>
    /// <param name="ATemplate"> (string) Шаблон строки записи</param>
    /// <param name="AParams"> (array of const) Параметры для заполенения
    /// шаблона</param>
    procedure LogString(ALevel: TLogLevel; ATemplate: string; AParams: array of
        const); stdcall;
    /// <summary>ILogger.LogInfo
    /// Зарегистрировать в журнале информационную запись
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogInfo(ATemplate: string; AParams: array of
        const); stdcall;
    /// <summary>ILogger.LogDebug
    /// Зарегистрировать в журнале отладочную запись
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogDebug(ATemplate: string; AParams: array of
        const); stdcall;
    /// <summary>ILogger.LogError
    /// Зарегистрировать в журнале запись об ошибке
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogError(ATemplate: string; AParams: array of
        const); stdcall;
    /// <summary>ILogger.LogWarning
    /// Зарегистрировать в журнале  запись-предупреждение
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogWarning(ATemplate: string; AParams: array of
        const); stdcall;
  end;

implementation

end.
