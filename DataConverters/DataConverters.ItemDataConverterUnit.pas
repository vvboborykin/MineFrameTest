{*******************************************************
* Project: MineFrameTest
* Unit: DataConverters.ItemDataConverterUnit.pas
* Description: Базовый класс для преобразования двоичных данных
*   в скалярное значение
*
* Created: 01.07.2023 19:20:09
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataConverters.ItemDataConverterUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.IOUtils, Generics.Collections, System.Math, DataImport.ColumnUnit,
  DataImport.RowUnit;

type
  /// <summary>TDataConverterContext
  /// Контекст преобразования
  /// </summary>
  TDataConverterContext = class
  public
     ABuffer: TBytes;
     AColumn: TColumn;
     ARow: TRow;
     AItem: TRowItem;
     Encoding: TEncoding;
  end;

  TItemDataConverter = class abstract
  public
    /// <summary>TItemDataConverter.GetItemData
    /// Преобразовать двоичные данные контекста в скалярное значение
    /// </summary>
    /// <param name="AContext"> (TDataConverterContext) Контекст</param>
    procedure GetItemData(AContext: TDataConverterContext); virtual; abstract;
  end;

  TItemDataConverterClass = class of TItemDataConverter;

implementation

end.
