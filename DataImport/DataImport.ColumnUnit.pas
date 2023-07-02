{*******************************************************
* Project: MineFrameTest
* Unit: ColumnUnit.pas
* Description: Определение колонки данных файла MICROMINE
*
* Created: 01.07.2023 19:13:26
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.ColumnUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.IOUtils, Generics.Collections, System.Math;

type
  TColumnDataType = (cdtDouble, cdtNatural, cdtString);

const
  CColumnDataTypeChars: array[Low(TColumnDataType)..High(TColumnDataType)] of
    string = ('R', 'N', 'C');

type
  /// <summary>
  /// TColumnОпределение колонки данных файла MICROMINE
  /// </summary>
  TColumn = class(TObject)
  private
    FDataType: TColumnDataType;
    FDisplayName: Variant;
    FLen: Integer;
    FName: string;
    FPrecision: Integer;
    procedure SetDataType(const Value: TColumnDataType);
    procedure SetDisplayName(const Value: Variant);
    procedure SetLen(const Value: Integer);
    procedure SetName(const Value: string);
    procedure SetPrecision(const Value: Integer);
  public
    // Строковое представление колонки
    function ToString: string; override;
    /// <summary>TColumn.DataType
    /// Тип данных колонки
    /// </summary>
    /// type:TColumnDataType
    property DataType: TColumnDataType read FDataType write SetDataType;
    /// <summary>TColumn.DisplayName
    /// Отображаемое имя
    /// </summary>
    /// type:Variant
    property DisplayName: Variant read FDisplayName write SetDisplayName;
    /// <summary>TColumn.Len
    /// Длина данных колонки в байтах
    /// </summary>
    /// type:Integer
    property Len: Integer read FLen write SetLen;
    /// <summary>TColumn.Name
    /// Наименование колонки данных (латиница без пробелов)
    /// </summary>
    /// type:string
    property Name: string read FName write SetName;
    /// <summary>TColumn.Precision
    /// Точность, для данных с плавающей запятой
    /// </summary>
    /// type:Integer
    property Precision: Integer read FPrecision write SetPrecision;
  end;

implementation

procedure TColumn.SetDataType(const Value: TColumnDataType);
begin
  FDataType := Value;
end;

procedure TColumn.SetDisplayName(const Value: Variant);
begin
  FDisplayName := Value;
end;

procedure TColumn.SetLen(const Value: Integer);
begin
  FLen := Value;
end;

procedure TColumn.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TColumn.SetPrecision(const Value: Integer);
begin
  FPrecision := Value;
end;

function TColumn.ToString: string;
begin
  Result := Name.PadRight(10, ' ') + CColumnDataTypeChars[DataType] +
    Len.ToString.PadLeft(3, ' ') + Precision.ToString.PadLeft(3, ' ');

  var vDisplayName := VarToStr(DisplayName);
  if vDisplayName <> EmptyStr then
    Result := Result + '|' + vDisplayName.PadRight(255, ' ');
end;

end.
