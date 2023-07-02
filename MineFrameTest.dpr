program MineFrameTest;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  Progress.IProgressUnit in 'Progress\Progress.IProgressUnit.pas',
  Log.ILoggerUnit in 'Log\Log.ILoggerUnit.pas',
  Log.BaseLoggerUnit in 'Log\Log.BaseLoggerUnit.pas',
  Log.NullLoggerUnit in 'Log\Log.NullLoggerUnit.pas',
  Progress.NullProgressUnit in 'Progress\Progress.NullProgressUnit.pas',
  Progress.DelegatedProgressUnit in 'Progress\Progress.DelegatedProgressUnit.pas',
  DataImport.MicromineImportService in 'DataImport\DataImport.MicromineImportService.pas',
  DataImport.ColumnUnit in 'DataImport\DataImport.ColumnUnit.pas',
  DataImport.RowUnit in 'DataImport\DataImport.RowUnit.pas',
  DataConverters.ItemDataConverterUnit in 'DataConverters\DataConverters.ItemDataConverterUnit.pas',
  DataConverters.DoubleDataConverterUnit in 'DataConverters\DataConverters.DoubleDataConverterUnit.pas',
  DataConverters.ItemDataConverterFactoryUnit in 'DataConverters\DataConverters.ItemDataConverterFactoryUnit.pas',
  DataConverters.StrNumericDataConverterUnit in 'DataConverters\DataConverters.StrNumericDataConverterUnit.pas',
  DataConverters.StringDataConverterUnit in 'DataConverters\DataConverters.StringDataConverterUnit.pas',
  Log.DelegatedLoggerUnit in 'Log\Log.DelegatedLoggerUnit.pas',
  DataExport.ExportServiceFactoryUnit in 'DataExport\DataExport.ExportServiceFactoryUnit.pas',
  DataExport.CsvExportServiceUnit in 'DataExport\DataExport.CsvExportServiceUnit.pas',
  DataExport.CsvExportContextUnit in 'DataExport\DataExport.CsvExportContextUnit.pas',
  DataExport.ExportContextUnit in 'DataExport\DataExport.ExportContextUnit.pas',
  DataExport.TxtExportServiceUnit in 'DataExport\DataExport.TxtExportServiceUnit.pas',
  DataExport.TxtExportContextUnit in 'DataExport\DataExport.TxtExportContextUnit.pas',
  DataExport.BaseExportServiceUnit in 'DataExport\DataExport.BaseExportServiceUnit.pas',
  ExportGui.ExportFormUnit in 'ExportGui\ExportGui.ExportFormUnit.pas' {ExportForm},
  DataExport.ExportFormatRegistryUnit in 'DataExport\DataExport.ExportFormatRegistryUnit.pas',
  ExportGui.ExportContextFormRegistryUnit in 'ExportGui\ExportGui.ExportContextFormRegistryUnit.pas',
  ExportGui.BaseContextEditorUnit in 'ExportGui\ExportGui.BaseContextEditorUnit.pas' {BaseContextEditor},
  ExportGui.CsvContextEditorUnitt in 'ExportGui\ExportGui.CsvContextEditorUnitt.pas' {CsvContextEditor},
  ExportGui.CodePageContextEditorUnit in 'ExportGui\ExportGui.CodePageContextEditorUnit.pas' {CodePageContextEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
