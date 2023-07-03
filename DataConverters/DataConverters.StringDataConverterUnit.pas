{*******************************************************
* Project: MineFrameTest
* Unit: DataConverters.StringDataConverterUnit.pas
* Description: Конвертер двоичных данных в строку
*
* Created: 01.07.2023 19:23:08
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataConverters.StringDataConverterUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.IOUtils, Generics.Collections, System.Math, DataImport.MicroMine.ColumnUnit,
  DataImport.MicroMine.RowUnit,  DataConverters.ItemDataConverterUnit;

type
  /// <summary>TStringDataConverter
  /// Конвертер двоичных данных в строку
  /// </summary>
  TStringDataConverter = class(TItemDataConverter)
  private
  public
    /// <summary>TDoubleDataConverter.GetItemData
    /// Преобразовать двоичные данные контекста в строку (пробелы в начале
    /// и конце строки отбрасываются)
    /// </summary>
    /// <param name="AContext"> (TDataConverterContext) Контекст</param>
    procedure GetItemData(AContext: TDataConverterContext); override;
  end;

implementation

procedure TStringDataConverter.GetItemData(AContext: TDataConverterContext);
begin
  with AContext do
  begin
    AItem.Value := Encoding.GetString(ABuffer).Trim();
  end;
end;

end.
