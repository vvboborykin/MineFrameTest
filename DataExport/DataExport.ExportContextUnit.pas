{*******************************************************
* Project: MineFrameTest
* Unit: DataExport.ExportContextUnit.pas
* Description: Базовый класс для контекстов экспорта данных
*
* Created: 02.07.2023 11:52:50
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.ExportContextUnit;

interface

uses
  Data.DB;

type
  TExportContextClass = class of TExportContext;

  /// <summary>TExportContext
  /// Базовый класс для контекстов экспорта данных
  /// </summary>
  TExportContext = class abstract
  private
    FDataSet: TDataSet;
    FFileName: string;
    FCodePage: Integer;
  public
    constructor Create; virtual;
    class function FileExtension: String; virtual; abstract;
    /// <summary>TExportContext.DataSet
    /// Данные для экспорта
    /// </summary>
    /// type:TDataSet
    property DataSet: TDataSet read FDataSet write FDataSet;
    /// <summary>TExportContext.FileName
    /// Имя результирующего файла
    /// </summary>
    /// type:string
    property FileName: string read FFileName write FFileName;
    /// <summary>TExportContext.CodePage
    /// Код кодировки текста в которой необходимо сохранять данные
    /// </summary>
    /// type:Integer
    property CodePage: Integer read FCodePage write FCodePage;
  end;

implementation

const
  СDefaultCodePage = 1251;


constructor TExportContext.Create;
begin
  inherited Create;
  FCodePage := СDefaultCodePage;
end;

end.
