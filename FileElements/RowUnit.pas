{*******************************************************
* Project: MineFrameTest
* Unit: RowUnit.pas
* Description: Запись данных файла MICROMINE
*
* Created: 01.07.2023 19:13:05
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit RowUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.IOUtils, Generics.Collections, System.Math, ColumnUnit;

type
  /// <summary>TRowItem
  /// Значение данныз в составе записи MICROMINE
  /// </summary>
  TRowItem = class
  private
    FColumn: TColumn;
    FValue: Variant;
    procedure SetColumn(const Value: TColumn);
    procedure SetValue(const Value: Variant);
  public
    /// <summary>TRowItem.Column
    /// Определение типа колонки данного элемента данных
    /// </summary>
    /// type:TColumn
    property Column: TColumn read FColumn write SetColumn;
    /// <summary>TRowItem.Value
    /// Значение элемента данных
    /// </summary>
    /// type:Variant
    property Value: Variant read FValue write SetValue;
  end;

  /// <summary>TRow
  /// Запись данных файла MICROMINE
  /// </summary>
  TRow = class(TObjectList<TRowItem>)
  end;

implementation

procedure TRowItem.SetColumn(const Value: TColumn);
begin
  FColumn := Value;
end;

procedure TRowItem.SetValue(const Value: Variant);
begin
  FValue := Value;
end;

end.
