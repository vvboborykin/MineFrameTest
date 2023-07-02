unit ExportGui.ExportContextFormRegistryUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  Generics.Collections, DataExport.ExportContextUnit, VCl.Forms,
  ExportGui.BaseContextEditorUnit;

type
  TExportContextFormRegistry = class(TDictionary<TExportContextClass, TBaseContextEditorClass>)
  end;

function ExportContextFormRegistry: TExportContextFormRegistry;

implementation
var
  FExportContextFormRegistry: TExportContextFormRegistry;

function ExportContextFormRegistry: TExportContextFormRegistry;
begin
  Result := FExportContextFormRegistry;
end;

initialization
  FExportContextFormRegistry := TExportContextFormRegistry.Create;
finalization
  FExportContextFormRegistry.Free;
end.
