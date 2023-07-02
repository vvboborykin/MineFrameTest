unit DataExport.DataSetExportServiceFactoryUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  DataExport.DataSetExportServiceUnit, DataExport.ExportContextUnit;

type
  TDataSetExportServiceFactory = class
  public
    class function CreateExportService(AContext: TExportContext):
        TDataSetExportService;
  end;

implementation

uses
  DataExport.DataSetToCsvUnit, DataExport.CsvExportContextUnit;

class function TDataSetExportServiceFactory.CreateExportService(AContext:
    TExportContext): TDataSetExportService;
begin
  Result := nil;
  if AContext is TCsvExportContext then
    Result := TDataSetToCsvExportService.Create(AContext as TCsvExportContext);
end;

end.
