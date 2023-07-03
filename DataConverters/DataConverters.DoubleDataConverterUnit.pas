{*******************************************************
* Project: MineFrameTest
* Unit: DataConverters.DoubleDataConverterUnit.pas
* Description: Конвертер двоичных данных в Double
*
* Created: 01.07.2023 19:19:10
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataConverters.DoubleDataConverterUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.IOUtils, Generics.Collections, System.Math, DataImport.MicroMine.ColumnUnit,
  DataImport.MicroMine.RowUnit,  DataConverters.ItemDataConverterUnit;

type
  /// <summary>TDoubleDataConverter
  /// Конвертер двоичных данных в Double
  /// </summary>
  TDoubleDataConverter = class(TItemDataConverter)
  public
    /// <summary>TDoubleDataConverter.GetItemData
    /// Преобразовать двоичные данные контекста в значение Double
    /// </summary>
    /// <param name="AContext"> (TDataConverterContext) Контекст</param>
    procedure GetItemData(AContext: TDataConverterContext); override;
  end;

implementation

procedure TDoubleDataConverter.GetItemData(AContext: TDataConverterContext);
begin
  AContext.AItem.Value := PDouble(AContext.ABuffer)^
end;

end.
