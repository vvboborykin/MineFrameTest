{*******************************************************
* Project: MineFrameTest
* Unit: DataExport.ExportFormatRegistryUnit.pas
* Description: Реестр форматов экспорта
*
* Created: 02.07.2023 12:59:13
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataExport.ExportFormatRegistryUnit;

interface
uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, Generics.Collections,
  DataExport.ExportContextUnit, DataExport.BaseExportServiceUnit;

type
  /// <summary>TExportFormat
  /// Формат экспорта
  /// </summary>
  TExportFormat = class
  private
    FContextClass: TExportContextClass;
    FDisplayName: string;
    FExportServiceClass: TExportServiceClass;
    procedure SetContextClass(const Value: TExportContextClass);
    procedure SetDisplayName(const Value: string);
    procedure SetExportServiceClass(const Value: TExportServiceClass);
  public
    constructor Create(AContextClass: TExportContextClass; AExportServiceClass:
        TExportServiceClass; const ADisplayName: string);
    /// <summary>TExportFormat.ContextClass
    /// Класс контекста экспорта
    /// </summary>
    /// type:TExportContextClass
    property ContextClass: TExportContextClass read FContextClass write
        SetContextClass;
    /// <summary>TExportFormat.DisplayName
    /// Имя формата
    /// </summary>
    /// type:string
    property DisplayName: string read FDisplayName write SetDisplayName;
    /// <summary>TExportFormat.ExportServiceClass
    /// Класс сервиса экспорта заданного формата
    /// </summary>
    /// type:TExportServiceClass
    property ExportServiceClass: TExportServiceClass read FExportServiceClass write
        SetExportServiceClass;
  end;

  /// <summary>TExportFormatRegistry
  /// Реестр форматов экспорта
  /// </summary>
  TExportFormatRegistry = class(TObjectList<TExportFormat>)
  strict protected
  public
    /// <summary>TExportFormatRegistry.FindContextClass
    /// Найти запись рееста для заданного класса контекста экспорта
    /// </summary>
    /// <returns> TExportFormat
    /// </returns>
    /// <param name="AClass"> (TExportContextClass) Класс контекста</param>
    function FindContextClass(AClass: TExportContextClass): TExportFormat;
  end;

/// <summary>procedure ExportFormatRegistry
/// Синглтон реестра
/// </summary>
/// <returns> TExportFormatRegistry
/// </returns>
function ExportFormatRegistry: TExportFormatRegistry;

implementation

var
  FExportFormatRegistry: TExportFormatRegistry;

function ExportFormatRegistry: TExportFormatRegistry;
begin
  Result := FExportFormatRegistry;
end;

constructor TExportFormat.Create(AContextClass: TExportContextClass;
    AExportServiceClass: TExportServiceClass; const ADisplayName: string);
begin
  inherited Create;
  FContextClass := AContextClass;
  FExportServiceClass := AExportServiceClass;
  FDisplayName := ADisplayName;
end;

procedure TExportFormat.SetContextClass(const Value: TExportContextClass);
begin
  FContextClass := Value;
end;

procedure TExportFormat.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
end;

procedure TExportFormat.SetExportServiceClass(const Value: TExportServiceClass);
begin
  FExportServiceClass := Value;
end;

function TExportFormatRegistry.FindContextClass(AClass: TExportContextClass):
    TExportFormat;
begin
  Result := nil;
  for var vCurrentFormat in Self do
  begin
    if AClass = vCurrentFormat.ContextClass then
    begin
      Result := vCurrentFormat;
      Break;
    end;
  end;
end;

initialization
  FExportFormatRegistry := TExportFormatRegistry.Create;
finalization
  FExportFormatRegistry.Free;
end.
