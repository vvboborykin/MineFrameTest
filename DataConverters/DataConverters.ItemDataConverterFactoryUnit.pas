{*******************************************************
* Project: MineFrameTest
* Unit: DataConverters.ItemDataConverterFactoryUnit.pas
* Description: Фабрика создающая конверторы данных
*
* Created: 01.07.2023 19:16:25
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataConverters.ItemDataConverterFactoryUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.IOUtils, Generics.Collections, System.Math, ColumnUnit,
  RowUnit, DataConverters.ItemDataConverterUnit;

type
  /// <summary>TItemDataConverterFactory
  /// Фабрика создающая конверторы данных
  /// </summary>
  TItemDataConverterFactory = class
    /// <summary>TItemDataConverterFactory.CreateDataConverter
    /// Контекст для которого создается конвертер
    /// </summary>
    /// <returns> TItemDataConverter
    /// </returns>
    /// <param name="AContext"> (TDataConverterContext) </param>
    class function CreateDataConverter(AContext: TDataConverterContext):
        TItemDataConverter;
  end;

implementation

uses
  DataConverters.DoubleDataConverterUnit,
  DataConverters.StrNumericDataConverterUnit,
  DataConverters.StringDataConverterUnit;

class function TItemDataConverterFactory.CreateDataConverter(AContext:
    TDataConverterContext): TItemDataConverter;
begin
  with AContext do
  begin
    if (AColumn.DataType = cdtDouble) then
    begin
      if AColumn.Len = 8 then
        // для нового формата
        Result := TDoubleDataConverter.Create
      else
        // для старого формата данные Double хранятся как строка
        Result := TStrNumericDataConverter.Create
    end
    else
    if (AColumn.DataType = cdtNatural) then
      // Конвертер строкового представления в натуральное число
      Result := TStrNumericDataConverter.Create
    else
      // Конвертер по умолчанию - строковый
      Result := TStringDataConverter.Create;
  end;
end;

end.

