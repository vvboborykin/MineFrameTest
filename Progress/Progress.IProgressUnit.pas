{*******************************************************
* Project: MineFrameTest
* Unit: Progress.IProgressUnit.pas
* Description: ���������� ���������� ����������� ��������� ���������� ������
*
* Created: 01.07.2023 18:53:21
* Copyright (C) 2023 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Progress.IProgressUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils;

type
  /// <summary>IProgress ��������� ����������� ��������� ���������� ������
  /// </summary>
  IProgress = interface
  ['{F1B89512-7C37-4C50-ADF4-378CC32B984D}']
    /// <summary>IProgress.ShowText
    /// �������� ����� ��������� ��������� ������
    /// </summary>
    /// <param name="ATemplate"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure ShowText(ATemplate: string; AParams: array of const); stdcall;
    /// <summary>IProgress.ShowPercent
    /// �������� ������� ���������� ������
    /// </summary>
    /// <param name="APercent"> (Double) </param>
    procedure ShowPercent(APercent: Double); stdcall;
  end;


implementation

end.
