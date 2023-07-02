{*******************************************************
* Project: MineFrameTest
* Unit: Progress.NullProgressUnit.pas
* Description: ������ ���������� IProgress - ��������
*
* Created: 01.07.2023 18:55:05
* Copyright (C) 2023 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Progress.NullProgressUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Progress.IProgressUnit;

type
  /// <summary>TNullProgress
  /// ������ ���������� IProgress - ��������
  /// </summary>
  TNullProgress = class(TInterfacedObject, IProgress)
  strict private
    procedure ShowText(ATemplate: string; AParams: array of const); stdcall;
    procedure ShowPercent(APercent: Double); stdcall;
  end;

implementation

procedure TNullProgress.ShowPercent(APercent: Double);
begin
  // none
end;

procedure TNullProgress.ShowText(ATemplate: string; AParams: array of const);
begin
  // none
end;

end.
