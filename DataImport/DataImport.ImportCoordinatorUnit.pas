unit DataImport.ImportCoordinatorUnit;

interface

uses
  System.Generics.Collections, DataImport.ImportFormatUnit,
  DataImport.ImportContextUnit, System.SysUtils,
  System.Classes,
  System.Variants, System.StrUtils,
  System.IOUtils, Generics.Collections, Progress.IProgressUnit, Log.ILoggerUnit,
  System.Threading, DataImport.ImportFormatRegistryUnit;

type
  TImportCoordinator = class
  strict private
    FSourceStream: TStream;
    procedure DoAfterImport;
    procedure DoProcessMessages;
    function GetFormat(AFileName: string): TImportFormat;
    procedure DoImportUsingFormat(AFileName: string; AFormat: TImportFormat; ATask:
        ITask);
    function SelectFormat(AFileName: string;
      AList: TList<DataImport.ImportFormatUnit.TImportFormat>): TImportFormat;
  private
    FAfterImport: TNotifyEvent;
    FContext: TImportContext;
    FProcessMessages: TProc;
  public
    function ImportFromFileAsync(AImportContext: TImportContext; AFileName:
      string; AfterImport: TNotifyEvent; AProcessMessages: TProc): ITask;
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

procedure TImportCoordinator.DoAfterImport;
begin
  if Assigned(FAfterImport) then
    TThread.Synchronize(nil,
      procedure
      begin
        FAfterImport(FContext)
      end)
end;

procedure TImportCoordinator.DoProcessMessages;
begin
  if Assigned(FProcessMessages) then
    TTHread.Synchronize(nil,
      procedure
      begin
        FProcessMessages()
      end);
end;

function TImportCoordinator.GetFormat(AFileName: string): TImportFormat;
begin
  var vFormats := TList<TImportFormat>.Create;
  try
    var vFileExt := TPath.GetExtension(AFileName);
    ImportFormatRegistry.SelectFormatsForFileExtension(vFileExt, vFormats);

    if vFormats.Count = 0 then
      raise Exception.CreateFmt(SNotregisteregFormatForExtension, [vFileExt]);

    var vFormat := SelectFormat(AFileName, vFormats);
    if vFormats = nil then
      raise Exception.CreateFmt(SInvalidFileData, [AFileName]);
    Result := vFormat;
  finally
    vFormats.Free;
  end;
end;

function TImportCoordinator.ImportFromFileAsync(AImportContext: TImportContext;
  AFileName: string; AfterImport: TNotifyEvent; AProcessMessages: TProc): ITask;

type
  TAsyncContext = record
    Task: ITask;
  end;
var
  AsyncContext : TAsyncContext;

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



  AsyncContext.Task := TTask.Create(
    procedure
    begin
      try
        try
          FContext.Logger.LogInfo(SImportFromFileStarted, [AFileName]);
          var vFormat := GetFormat(AFileName);
          DoImportUsingFormat(AFileName, vFormat, AsyncContext.Task);
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
    end);

  Result := AsyncContext.Task;
  Result.ExecuteWork;
end;

procedure TImportCoordinator.DoImportUsingFormat(AFileName: string; AFormat:
    TImportFormat; ATask: ITask);
begin
  var vFileStream := TBufferedFileStream.Create(AFileName, fmOpenRead,
    fmShareDenyWrite);
  try
    var vImportService := AFormat.ImportServiceClass.Create(FContext);
    try
      vImportService.ImportData(vFileStream, ATask);
    finally
      vImportService.Free;
    end;
  finally
    vFileStream.Free;
  end;
end;

function TImportCoordinator.SelectFormat(AFileName: string; AList: TList<
  TImportFormat>): TImportFormat;
begin
  Result := nil;
  var vFileStream := TBufferedFileStream.Create(AFileName, fmOpenRead,
    fmShareDenyWrite);
  try
    for var vFormat in AList do
    begin
      var vFormatDetector := vFormat.DetectorClass.Create(vFileStream, FContext.Logger);
      try
        if vFormatDetector.IsValidFormat then
        begin
          Result := vFormat;
          Break;
        end;
      finally
        vFormatDetector.Free;
      end;
      DoProcessMessages();
    end;
  finally
    vFileStream.Free;
  end;
end;

end.
