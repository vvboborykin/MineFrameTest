{*******************************************************
* Project: MineFrameTest
* Unit: DataExport.ExportServiceFactoryUnit.pas
* Description: Фабрика сервисов экспорта данных
*
* Created: 02.07.2023 12:27:05
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.ExportServiceFactoryUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  DataExport.BaseExportServiceUnit, DataExport.ExportContextUnit;

type
  /// <summary>TDataSetExportServiceFactory
  /// Фабрика сервисов экспорта данных
  /// </summary>
  TDataSetExportServiceFactory = class
  public
    /// <summary>TDataSetExportServiceFactory.CreateExportService
    /// Создать сервис экспорта данных для переданного контекста экспорта
    /// </summary>
    /// <returns> IExportService
    /// </returns>
    /// <param name="AContext"> (TExportContext) Типизированный контекст экспорта</param>
    class function CreateExportService(AContext: TExportContext):
        IExportService;
  end;

implementation

uses
  DataExport.ExportFormatRegistryUnit;

resourcestring
  SExportFormatTorRegistered = 'Не найдена запись в реестре форматов экспорта для класса %s';

class function TDataSetExportServiceFactory.CreateExportService(AContext:
    TExportContext): IExportService;
begin
  var vFormat := ExportFormatRegistry
    .FindContextClass(TExportContextClass(AContext.ClassType));

  if vFormat = nil then
    raise Exception.CreateFmt(SExportFormatTorRegistered,
      [AContext.ClassName]);

  Result := vFormat.ExportServiceClass.Create(AContext);
end;

end.
