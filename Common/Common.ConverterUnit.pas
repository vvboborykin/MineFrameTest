{*******************************************************
* Project: MineFrameTest
* Unit: ImportConverter.ConverterUnit.pas
* Description: Дженерик загрузки данных из объекта-источника в
*  объект-приемник данных
*
* Created: 04.07.2023 22:19:40
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Common.ConverterUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Common.AsyncWorkerUnit, Common.AsyncContextUnit, Progress.IProgressUnit,
  Log.ILoggerUnit;

type
  /// <summary>TConverter
  /// Дженерик загрузки данных из объекта-источника в объект-приемник данных
  /// </summary>
  TConverter<TSource, TTarget: class> = class abstract(TAsyncWorker)
  strict private
    FTarget: TTarget;
    FSource: TSource;
  strict protected
    procedure ValidateParameters; virtual;
  public
    constructor Create(ALogger: ILogger; AProgress: IProgress; ASource: TSource;
        ATarget: TTarget; AContext: TObject);
    /// <summary>TConverter<,>.Target
    /// Объект - источник данных
    /// </summary>
    /// type:TTarget
    property Target: TTarget read FTarget;
    /// <summary>TConverter<,>.Source
    /// Объект получатель данных
    /// </summary>
    /// type:TSource
    property Source: TSource read FSource;
  end;

resourcestring
  SConvertionAborted = 'Преобразование прервано';
  STargetIsNil = 'Аргумент Target не задан';
  SSourceIsNil = 'Аргумент Source не задан';

implementation


constructor TConverter<TSource, TTarget>.Create(ALogger: ILogger; AProgress:
    IProgress; ASource: TSource; ATarget: TTarget; AContext: TObject);
begin
  inherited Create(ALogger, AProgress, AContext);
  FSource := ASource;
  FTarget := ATarget;
  ValidateParameters();
end;

procedure TConverter<TSource, TTarget>.ValidateParameters;
begin
  if Source = nil then
    raise EArgumentNilException.Create(SSourceIsNil);
  if Target = nil then
    raise EArgumentNilException.Create(STargetIsNil);
end;

end.

