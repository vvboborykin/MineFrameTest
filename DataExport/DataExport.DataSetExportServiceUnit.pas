{*******************************************************
* Project: MineFrameTest
* Unit: Export.DataSetExportServiceUnit.pas
* Description: Базовый класс для служб текстового экспорта данных
*
* Created: 01.07.2023 21:24:53
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.DataSetExportServiceUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, System.IOUtils, Data.DB,
  MicromineImportService, ColumnUnit, RowUnit, DataExport.ExportContextUnit;

type
  TDataSetExportService = class abstract
  private
    FContext: TExportContext;
  protected
    function GetHeader: string; virtual; abstract;
    function GetRecordLine: string; virtual; abstract;
  public
    constructor Create(AContext: TExportContext);
    /// <summary>TDataSetExportService.ExportDataSetToFile
    /// Экспортировать данные из набора данных в файл
    /// </summary>
    procedure ExportDataSetToFile; virtual;
    /// <summary>TDataSetExportService.Context
    /// Крнтекст экспорта
    /// </summary>
    /// type:TExportContext
    property Context: TExportContext read FContext;
  end;

implementation


constructor TDataSetExportService.Create(AContext: TExportContext);
begin
  inherited Create;
  FContext := AContext;
end;

procedure TDataSetExportService.ExportDataSetToFile;
begin
  var vDataSet := Context.DataSet;
  if vDataSet.IsEmpty then
    Exit;

  var vLines: TArray<string>;

  var vRecNo := vDataSet.RecNo;
  vDataSet.DisableControls;
  try
    vLines := vLines + [GetHeader()];
    vDataSet.First;
    while not vDataSet.Eof do
    begin
      vLines := vLines + [GetRecordLine()];
      vDataSet.Next;
    end;
    TFile.WriteAllLines(Context.FileName, vLines,
      TEncoding.GetEncoding(Context.CodePage));
  finally
    vDataSet.RecNo := vRecNo;
    vDataSet.EnableControls;
  end;
end;

end.
