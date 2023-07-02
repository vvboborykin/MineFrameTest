{*******************************************************
* Project: MineFrameTest
* Unit: DataConverters.StrNumericDataConverterUnit.pas
* Description: Конвертер двоичных данных строкового представления в число
*
* Created: 01.07.2023 19:24:23
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataConverters.StrNumericDataConverterUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.IOUtils, Generics.Collections, System.Math, DataImport.ColumnUnit,
  DataImport.RowUnit,  DataConverters.ItemDataConverterUnit;

type
  /// <summary>TStrNumericDataConverter
  /// Конвертер двоичных данных строкового представления в число
  /// </summary>
  TStrNumericDataConverter = class(TItemDataConverter)
  strict private
    procedure ConvertToNatural(AContext: TDataConverterContext; AStringNum: string);
    procedure ConvertToDouble(AContext: TDataConverterContext; AStringNum: string);
  private
  public
    /// <summary>TStrNumericDataConverter.GetItemData
    /// Преобразовать двоичные данные чтрокового представления в число
    /// </summary>
    /// <param name="AContext"> (TDataConverterContext) Контекст</param>
    procedure GetItemData(AContext: TDataConverterContext); override;
  end;

implementation

resourcestring
  SStrToNauralNumberConversionError = 'Ошибка преобразования строки в число в колонке %s';

procedure TStrNumericDataConverter.ConvertToNatural(AContext:
    TDataConverterContext; AStringNum: string);
begin
  var vIntValue: Integer := 0;
  if Integer.TryParse(AStringNum, vIntValue ) then
    AContext.AItem.Value := vIntValue
  else
    raise Exception.CreateFmt(SStrToNauralNumberConversionError,
      [AContext.AColumn.Name]);
end;

procedure TStrNumericDataConverter.ConvertToDouble(AContext:
    TDataConverterContext; AStringNum: string);
begin
  var vDoubleValue: Double := 0;
  if Double.TryParse(AStringNum, vDoubleValue ) then
    AContext.AItem.Value := vDoubleValue
  else
    raise Exception.CreateFmt(SStrToNauralNumberConversionError,
      [AContext.AColumn.Name]);
end;

procedure TStrNumericDataConverter.GetItemData(AContext: TDataConverterContext);
begin
    var vStrValue := AContext.Encoding.GetString(AContext.ABuffer).Trim()
      .Replace('.', FormatSettings.DecimalSeparator);

    if AContext.AColumn.DataType = cdtDouble then
      ConvertToDouble(AContext, vStrValue)
    else
      ConvertToNatural(AContext, vStrValue);
end;

end.
