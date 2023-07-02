unit DataExport.ExportContextUnit;

interface

uses
  Data.DB;

type
  TExportContext = class
  private
    FDataSet: TDataSet;
    FFileName: string;
    FCodePage: Integer;
  public
    constructor Create;
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
