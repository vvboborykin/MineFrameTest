{*******************************************************
* Project: MineFrameTest
* Unit: Progress.DelegatedProgressUnit.pas
* Description: Реализация IProgress с делегированием вывода данных
*  при помощи обработчикам событий
*
* Created: 01.07.2023 18:56:18
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Progress.DelegatedProgressUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.SyncObjs, Progress.IProgressUnit;

type
  // Событие вывода текста
  TShowTextEvent = procedure(Sender: TObject; AText: string) of object;

  // Событие вывода процента выполнения задачи
  TShowPercentEvent = procedure(Sender: TObject; APercent: Double) of object;

  /// <summary>TDelegatedProgress
  /// Реализация IProgress с делегированием вывода данных
  /// </summary>
  TDelegatedProgress = class(TInterfacedObject, IProgress)
  strict private
    FOnShowText: TShowTextEvent;
    FOnShowPercent: TShowPercentEvent;
    procedure ShowText(ATemplate: string; AParams: array of const); stdcall;
    procedure ShowPercent(APercent: Double); stdcall;
  public
    /// <summary>TDelegatedProgress.Create
    /// Инициализирующий конструктор
    /// </summary>
    /// <param name="AOnShowText"> (TShowTextEvent) Обработчик вывода текста</param>
    /// <param name="AShowPercentEvent"> (TShowPercentEvent) Обработчик вывода процента
    /// выполнения задачи</param>
    constructor Create(AOnShowText: TShowTextEvent; AShowPercentEvent:
        TShowPercentEvent);
  end;

implementation

constructor TDelegatedProgress.Create(AOnShowText: TShowTextEvent;
    AShowPercentEvent: TShowPercentEvent);
begin
  inherited Create;
  FOnShowText := AOnShowText;
  FOnShowPercent := AShowPercentEvent;
end;

procedure TDelegatedProgress.ShowPercent(APercent: Double);
begin
  if Assigned(FOnShowPercent) then
  begin
    TThread.Synchronize(nil,
      procedure
      begin
        FOnShowPercent(Self, APercent);
      end);
  end;
end;

procedure TDelegatedProgress.ShowText(ATemplate: string; AParams: array of const);
begin
  if Assigned(FOnShowText) then
  begin
    var vText := Format(ATemplate, AParams);
    TThread.Synchronize(nil,
      procedure
      begin
        FOnShowText(Self, vText);
      end);
  end;
end;

end.

