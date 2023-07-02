{*******************************************************
* Project: MineFrameTest
* Unit: Log.NullLoggerUnit.pas
* Description: Пустая реализация ILogger - заглушка
*
* Created: 01.07.2023 19:02:27
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Log.NullLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Log.BaseLoggerUnit;

type
  /// <summary>TNullLogger
  /// Пустая реализация ILogger - заглушка
  /// </summary>
  TNullLogger = class(TBaseLogger)
  strict protected
    procedure AddLogString(AText: string); override;
  end;


implementation

procedure TNullLogger.AddLogString(AText: string);
begin
  // none
end;

end.
