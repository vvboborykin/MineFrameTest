{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.DataSetBuilderUnit.pas
* Description: Модуль выгрузки результатов импорта в DataSet
*
* Created: 02.07.2023 21:13:11
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.MicroMine.DataSetBuilderUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, Data.DB,
  Datasnap.DBClient, DataImport.Micromine.ImportService, DataImport.MicroMine.ColumnUnit;

type
  /// <summary>TDataSetBuilder
  /// Класс - утилита выгрузки результатов импорта в DataSet
  /// </summary>
  TDataSetBuilder = class
  strict private
    FImportService: TImportService;
    FDataSet: TClientDataSet;
    procedure AppendRecordsToTable;
    procedure CreateDataFieldDefs;
    function GetFieldSizeOfColumn(vCurrentColumn: TColumn): Integer;
    function GetFieldTypeOfColumn(vCurrentColumn: TColumn): TFieldType;
    procedure LoadImportResultsToTable;
    procedure SetFieldDisplayNames;
  public
    constructor Create(AImportService: TImportService; ADataSet: TClientDataSet);
    /// <summary>TDataSetBuilder.BuildDataSetFromImportServiceResults
    /// Выгрузить результаты импорта в DataSet
    /// </summary>
    procedure BuildDataSetFromImportServiceResults;
  end;

implementation

constructor TDataSetBuilder.Create(AImportService: TImportService; ADataSet:
    TClientDataSet);
begin
  inherited Create;
  FImportService := AImportService;
  FDataSet := ADataSet;
end;

procedure TDataSetBuilder.AppendRecordsToTable;
begin
  for var vCurrentRow in FImportService.Rows do
  begin
    FDataSet.Append;
    for var vItem in vCurrentRow do
    begin
      FDataSet[vItem.Column.Name] := vItem.Value;
    end;
    FDataSet.Post;
  end;
end;

procedure TDataSetBuilder.BuildDataSetFromImportServiceResults;
begin
  LoadImportResultsToTable();
end;

procedure TDataSetBuilder.CreateDataFieldDefs;
begin
  for var vCurrentColumn in FImportService.Columns do
  begin
    FDataSet.FieldDefs.Add(vCurrentColumn.Name, GetFieldTypeOfColumn(vCurrentColumn),
      GetFieldSizeOfColumn(vCurrentColumn));
    var vDef := FDataSet.FieldDefs[FDataSet.FieldDefs.Count - 1];
    if vCurrentColumn.DataType = cdtDouble then
      vDef.Precision := vCurrentColumn.Precision;
  end;
end;

function TDataSetBuilder.GetFieldSizeOfColumn(vCurrentColumn: TColumn): Integer;
begin
  Result := 0;
  if vCurrentColumn.DataType = cdtString then
    Result := vCurrentColumn.Len;
end;

function TDataSetBuilder.GetFieldTypeOfColumn(vCurrentColumn: TColumn):
    TFieldType;
begin
  Result := ftString;
  case vCurrentColumn.DataType of
    cdtDouble:
      Result := ftFloat;
    cdtNatural:
      Result := ftInteger;
    cdtString:
      Result := ftString;
  end;
end;

procedure TDataSetBuilder.LoadImportResultsToTable;
begin
  FDataSet.Close;
  FDataSet.FieldDefs.Clear;
  CreateDataFieldDefs();
  FDataSet.CreateDataSet;
  SetFieldDisplayNames();
  AppendRecordsToTable();
end;

procedure TDataSetBuilder.SetFieldDisplayNames;
begin
  for var I := 0 to FDataSet.FieldCount - 1 do
  begin
    var vColumn := FImportService.Columns[I];
    var vDisplayName := VarToStr(vColumn.DisplayName);
    if (vDisplayName <> '') then
      FDataSet.Fields[I].DisplayLabel := vDisplayName;
  end;
end;

end.
