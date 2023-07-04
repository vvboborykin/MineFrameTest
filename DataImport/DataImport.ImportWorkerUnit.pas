{*******************************************************
* Project: MineFrameTest
* Unit: DataImport.ImportWorkerUnit.pas
* Description: Объект выполняющий импорт
*
* Created: 03.07.2023 23:03:12
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit DataImport.ImportWorkerUnit;

interface

uses
  System.Generics.Collections, DataImport.ImportFormatUnit,
  DataImport.ImportContextUnit, System.SysUtils, System.Classes, System.Variants,
  System.StrUtils, System.IOUtils, Generics.Collections, Progress.IProgressUnit,
  Log.ILoggerUnit, System.Threading, DataImport.ImportFormatRegistryUnit,
  DataImport.AsyncContextUnit;

type
  /// <summary>TImportWorker
  /// Объект выполняющий импорт
  /// </summary>
  TImportWorker = class
  strict private
    FAfterImport: TNotifyEvent;
    FContext: TImportContext;
    FProcessMessages: TProc;
    procedure DoAfterImport;
    procedure DoProcessMessages;
    function GetFormat(AFileName: string): TImportFormat;
    procedure DoImportUsingFormat(AFileName: string; AFormat: TImportFormat;
      AsyncContext: IAsyncContext);
    procedure ExecuteImport(AFileName: string; AsyncContext: IAsyncContext);
    function SelectFormat(AFileName: string; AList: TList<TImportFormat>):
      TImportFormat;
  public
    /// <summary>TImportWorker.ImportFromFileAsync
    /// Начать операцию импорта в фоновом вычислительном потоке
    /// </summary>
    /// <returns> ITask
    /// </returns>
    /// <param name="AImportContext"> (TImportContext) Контекст  операции
    /// импорта</param>
    /// <param name="AFileName"> (string) Имя файла - источника данных</param>
    /// <param name="AfterImport"> (TNotifyEvent) Обработчик события окончания
    /// импорта</param>
    /// <param name="AProcessMessages"> (TProc) Процедура обработки очережи сообшений
    /// приложения (вызывается для предотвращения "заморозки" GUI)</param>
    function ImportFromFileAsync(AImportContext: TImportContext; AFileName:
      string; AfterImport: TNotifyEvent; AProcessMessages: TProc): ITask;
    /// <summary>TImportWorker.ImportFromFileAsync
    /// Начать операцию импорта в основном вычислительном потоке
    /// </summary>
    /// <returns> ITask
    /// </returns>
    /// <param name="AImportContext"> (TImportContext) Контекст  операции
    /// импорта</param>
    /// <param name="AFileName"> (string) Имя файла - источника данных</param>
    /// <param name="AfterImport"> (TNotifyEvent) Обработчик события окончания
    /// импорта</param>
    /// <param name="AProcessMessages"> (TProc) Процедура обработки очережи сообшений
    /// приложения (вызывается для предотвращения "заморозки" GUI)</param>
    procedure ImportFromFile(AImportContext: TImportContext; AFileName: string);
  end;

implementation

resourcestring
  SImportFromFileStarted = 'Импорт из файла %s начат';
  SImportCompleted = 'Импорт завершен';
  SImportAborted = 'Импорт прерван';
  SInvalidFileData =
    'Содержимое файла %s не соответствует ни одному зарегистрированному формату';
  SFileNotFound = 'Файл %s не найден';
  SAImportContextParameterIsNil = 'Параметр AImportContext не задан';
  SNotregisteregFormatForExtension =
    'Для расширения файла %s не зарегистрирован формат импорта';

procedure TImportWorker.DoAfterImport;
begin
  if Assigned(FAfterImport) then
    TThread.Synchronize(nil,
      procedure
      begin
        FAfterImport(FContext)
      end)
end;

procedure TImportWorker.DoProcessMessages;
begin
  if Assigned(FProcessMessages) then
    TTHread.Synchronize(nil,
      procedure
      begin
        FProcessMessages()
      end);
end;

function TImportWorker.GetFormat(AFileName: string): TImportFormat;
begin
  var vFormats := TList<TImportFormat>.Create;
  try
    var vFileExt := TPath.GetExtension(AFileName);
    ImportFormatRegistry.SelectFormatsForFileExtension(vFileExt, vFormats);

    if vFormats.Count = 0 then
      raise Exception.CreateFmt(SNotregisteregFormatForExtension, [vFileExt]);

    var vFormat := SelectFormat(AFileName, vFormats);

    if vFormat = nil then
      raise Exception.CreateFmt(SInvalidFileData, [AFileName]);

    Result := vFormat;
  finally
    vFormats.Free;
  end;
end;

function TImportWorker.ImportFromFileAsync(AImportContext: TImportContext;
  AFileName: string; AfterImport: TNotifyEvent; AProcessMessages: TProc): ITask;

var
  AsyncContext: TTaskAsyncContext;

  procedure ValidateArguments();
  begin
    if AImportContext = nil then
      raise EArgumentException.Create(SAImportContextParameterIsNil);

    if not TFile.Exists(AFileName) then
      raise EFileNotFoundException.CreateFmt(SFileNotFound, [AFileName]);
  end;

  procedure StoreArgumentsInFields();
  begin
    FContext := AImportContext;
    FProcessMessages := AProcessMessages;
    FAfterImport := AfterImport;
  end;

begin
  ValidateArguments();
  StoreArgumentsInFields();

  AsyncContext := TTaskAsyncContext.Create(TTask.Create(
    procedure
    begin
      ExecuteImport(AFileName, AsyncContext as IAsyncContext);
    end));

  Result := AsyncContext.FTask;
  Result.ExecuteWork;
end;

procedure TImportWorker.DoImportUsingFormat(AFileName: string; AFormat:
  TImportFormat; AsyncContext: IAsyncContext);
begin
  var vFileStream := TBufferedFileStream.Create(AFileName, fmOpenRead,
    fmShareDenyWrite);
  try
    var vImportService := AFormat.ImportServiceClass.Create(FContext);
    try
      vImportService.ImportData(vFileStream, AsyncContext);
    finally
      vImportService.Free;
    end;
  finally
    vFileStream.Free;
  end;
end;

procedure TImportWorker.ExecuteImport(AFileName: string; AsyncContext:
  IAsyncContext);
begin
  try
    try
      FContext.Logger.LogInfo(SImportFromFileStarted, [AFileName]);
      var vFormat := GetFormat(AFileName);
      DoImportUsingFormat(AFileName, vFormat, AsyncContext);
      FContext.Logger.LogInfo(SImportCompleted, []);
    except
      on E: Exception do
      begin
        if E is EOperationCancelled then
          FContext.Logger.LogInfo(SImportAborted, [])
        else
          FContext.Logger.LogError('%s', [E.Message]);
      end;
    end;
  finally
    DoAfterImport();
  end;
end;

procedure TImportWorker.ImportFromFile(AImportContext: TImportContext; AFileName:
  string);
var
  AsyncContext: IAsyncContext;

  procedure ValidateArguments();
  begin
    if AImportContext = nil then
      raise EArgumentException.Create(SAImportContextParameterIsNil);

    if not TFile.Exists(AFileName) then
      raise EFileNotFoundException.CreateFmt(SFileNotFound, [AFileName]);
  end;

  procedure StoreArgumentsInFields();
  begin
    FContext := AImportContext;
    FAfterImport := nil;
    FProcessMessages := nil;
  end;

begin
  ValidateArguments();
  StoreArgumentsInFields();
  AsyncContext := TNullAsyncContext.Create;
  ExecuteImport(AFileName, AsyncContext);
end;

function TImportWorker.SelectFormat(AFileName: string; AList: TList<
  TImportFormat>): TImportFormat;
begin
  Result := nil;
  var vFileStream := TBufferedFileStream.Create(AFileName, fmOpenRead,
    fmShareDenyWrite);
  try
    for var vFormat in AList do
    begin
      if vFormat.IsValidFormat(vFileStream, FContext.Logger) then
      begin
        Result := vFormat;
        Break;
      end;
      DoProcessMessages();
    end;
  finally
    vFileStream.Free;
  end;
end;

end.

