{*******************************************************
* Project: MineFrameTest
* Unit: Log.NullLoggerUnit.pas
* Description: ������ ���������� ILogger - ��������
*
* Created: 01.07.2023 19:02:27
* Copyright (C) 2023 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Log.NullLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Log.BaseLoggerUnit;

type
  /// <summary>TNullLogger
  /// ������ ���������� ILogger - ��������
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
