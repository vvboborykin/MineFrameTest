{*******************************************************
* Project: MineFrameTest
* Unit: Log.ILoggerUnit.pas
* Description: ���������� ���������� ������� ������ ����������
*
* Created: 01.07.2023 18:58:55
* Copyright (C) 2023 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Log.ILoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils;

type
  // ������� ���������� ������� �������
  TLogLevel = (lolDebug, lolInfo, lolWarning, lolError);

  /// <summary>ILogger
  /// ��������� ������� ������ ����������
  /// </summary>
  ILogger = interface
    ['{394FB66C-73E8-4C9D-8A9E-BD07E4DADF03}']
    /// <summary>ILogger.LogString
    /// ���������������� � ������� ��������� ������
    /// </summary>
    /// <param name="ALevel"> (TLogLevel) ������� ���������� ������</param>
    /// <param name="ATemplate"> (string) ������ ������ ������</param>
    /// <param name="AParams"> (array of const) ��������� ��� �����������
    /// �������</param>
    procedure LogString(ALevel: TLogLevel; ATemplate: string; AParams: array of
        const); stdcall;
    /// <summary>ILogger.LogInfo
    /// ���������������� � ������� �������������� ������
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogInfo(ATemplate: string; AParams: array of
        const); stdcall;
    /// <summary>ILogger.LogDebug
    /// ���������������� � ������� ���������� ������
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogDebug(ATemplate: string; AParams: array of
        const); stdcall;
    /// <summary>ILogger.LogError
    /// ���������������� � ������� ������ �� ������
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogError(ATemplate: string; AParams: array of
        const); stdcall;
    /// <summary>ILogger.LogWarning
    /// ���������������� � �������  ������-��������������
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure LogWarning(ATemplate: string; AParams: array of
        const); stdcall;
  end;

implementation

end.
