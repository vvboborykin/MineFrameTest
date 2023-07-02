{*******************************************************
* Project: MineFrameTest
* Unit: DataExport.BaseExportServiceUnit.pas
* Description: Базовые структуры сервисов экспорта данных
*
* Created: 02.07.2023 13:02:19
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.BaseExportServiceUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.IOUtils, DataExport.ExportContextUnit, Data.DB;

type
  /// <summary>IExportService
  /// Интерфейс сервиса данных
  /// </summary>
  IExportService = interface
    ['{44B5A495-9A4D-4D54-8BB5-A2F73CA14664}']
    procedure ExportDataSetToFile;
  end;

  TExportServiceClass = class of TExportService;

  /// <summary>TExportService
  /// Нетипизированный базовый класс сервиса экспорта
  /// </summary>
  TExportService = class abstract(TInterfacedObject, IExportService)
  private
    FExportContext: TExportContext;
  strict protected
    property ExportContext: TExportContext read FExportContext;
  public
    constructor Create(AContext: TExportContext);
    /// <summary>TBaseExportService.ExportDataSetToFile
    /// Экспортировать данные из набора данных в файл
    /// </summary>
    procedure ExportDataSetToFile; virtual; abstract;
  end;

  /// <summary>TBaseExportService
  /// Типизированный базовый класс сервиса экспорта
  /// </summary>
  TBaseExportService<T: TExportContext> = class abstract(TExportService)
  strict private
  private
    function GetContext: T;
  strict protected
    function GetFooter: TArray<string>; virtual;
    function GetHeader: TArray<string>; virtual; abstract;
    function GetRecordLine: string; virtual; abstract;
  public
    constructor Create(AContext: T);
    /// <summary>TBaseExportService.ExportDataSetToFile
    /// Экспортировать данные из набора данных в файл
    /// </summary>
    procedure ExportDataSetToFile; override;
    /// <summary>TBaseExportService<>.Context
    /// Типизированный контекст экспорта
    /// </summary>
    /// type:T
    property Context: T read GetContext;
  end;

implementation

constructor TBaseExportService<T>.Create(AContext: T);
begin
  inherited Create(AContext);
end;

procedure TBaseExportService<T>.ExportDataSetToFile;
begin
  var vDataSet := Context.DataSet;
  if vDataSet.IsEmpty then
    Exit;

  var vLines: TArray<string> := nil;

  var vRecNo := vDataSet.RecNo;
  vDataSet.DisableControls;
  try
    vLines := vLines + GetHeader();
    vDataSet.First;
    while not vDataSet.Eof do
    begin
      vLines := vLines + [GetRecordLine()];
      vDataSet.Next;
    end;
    vLines := vLines + GetFooter();
    TFile.WriteAllLines(Context.FileName, vLines, TEncoding.GetEncoding(Context.CodePage));
  finally
    vDataSet.RecNo := vRecNo;
    vDataSet.EnableControls;
  end;
end;

function TBaseExportService<T>.GetContext: T;
begin
  Result := ExportContext as T;
end;

function TBaseExportService<T>.GetFooter: TArray<string>;
begin
  Result := [];
end;

constructor TExportService.Create(AContext: TExportContext);
begin
  inherited Create;
  FExportContext := AContext;
end;

end.

