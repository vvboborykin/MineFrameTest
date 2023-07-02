{*******************************************************
* Project: MineFrameTest
* Unit: MicromineImportService.pas
* Description: Сервис импорта данных из файла STR MICROMINE
*
* Created: 01.07.2023 18:26:44
* Copyright (C) 2023 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit MicromineImportService;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils,
  System.Threading, System.IOUtils, Generics.Collections, System.Math,
  ColumnUnit, RowUnit, Progress.IProgressUnit, Log.ILoggerUnit;

type
  /// <summary>TImportContext
  /// Контекст операции импорта
  /// </summary>
  TImportContext = class
  private
    FLogger: ILogger;
    FProgress: IProgress;
    FTask: ITask;
    procedure SetTask(const Value: ITask);
  public
    constructor Create(AProgress: IProgress; ALogger: ILogger; ATask: ITask);
    /// <summary>TImportContext.CancellationPending
    /// Определить запрошено ли прерывание
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function CancellationPending: Boolean;
    /// <summary>TImportContext.CheckCancel
    /// Проверка запроса прерывания выполнения задачи. В случае, если
    ///  запрос прерывания был зарегистрирован, то выбрасывается ошибка
    ///  EOperationCancelled
    /// </summary>
    procedure CheckCancel;
    /// <summary>TImportContext.Logger
    /// Журнал работы приложения
    /// </summary>
    /// type:ILogger
    property Logger: ILogger read FLogger;
    /// <summary>TImportContext.Progress
    /// Индикатор прогресса выполнения задачи
    /// </summary>
    /// type:IProgress
    property Progress: IProgress read FProgress;
    /// <summary>TImportContext.Task
    /// Фоновая задаяча в рамкахъ которой производится импорт
    /// </summary>
    /// type:ITask
    property Task: ITask read FTask write SetTask;
  end;

  /// <summary>TMicromineImportService
  /// Сервис импорта данных из файла STR MICROMINE
  /// </summary>
  TMicromineImportService = class
  strict private
    FCodePage: Integer;
    FColumns: TObjectList<TColumn>;
    FFormatMarker: string;
    FImportContext: TImportContext;
    FMetadataBytes: TBytes;
    FMetadataXml: string;
    FRows: TObjectList<TRow>;
    FVariablesCount: Integer;
    procedure AddLogInfo(AText: string; AParams: array of const);
    procedure AddRow(ARowBuffer: TBytes);
    procedure AddRowItem(AStreamOfRow: TStream; AColumn: TColumn; ARow: TRow);
    function BuffferEndsWithBytes(ABuffer, AEndMarker: TBytes): Boolean;
    procedure ConvertItemValueFromBytes(AColumn: TColumn; ARow: TRow; vBuffer:
      TBytes; vItem: TRowItem);
    function Encoding: TEncoding;
    function GetRowSize: LongInt;
    procedure ReadColumn(vFileStream: TBufferedFileStream);
    procedure ReadColumns(vFileStream: TBufferedFileStream);
    procedure ReadFormatMarker(vFileStream: TBufferedFileStream);
    procedure ReadMetadataBytes(vFileStream: TBufferedFileStream);
    function ReadMetadataXmlString(vFileStream: TBufferedFileStream): Boolean;
    procedure ReadRows(vFileStream: TBufferedFileStream);
    function ReadSection(vFileStream: TBufferedFileStream; AEndMarker: TBytes):
      TBytes;
    function ReadString(vFileStream: TBufferedFileStream): string;
    procedure ReadVariablesCount(vFileStream: TBufferedFileStream);
    procedure SetCodePage(const Value: Integer);
    procedure SetFormatMarker(const Value: string);
    procedure SetMetadataXml(const Value: string);
    procedure SetVariablesCount(const Value: Integer);
    procedure ShowProgresss(vFileStream: TBufferedFileStream);
    procedure ProcessAppMessages;
  public
    constructor Create(AImportContext: TImportContext);
    destructor Destroy; override;
    /// <summary>TMicromineImportService.ImportFromFile
    /// Импортировать данные из файла MICROMINE - главная операция сервиса
    /// </summary>
    /// <param name="AFileName"> (string) </param>
    procedure ImportFromFile(AFileName: string);
    // <summary>TMicromineImportService.CodePage
    // Номер кодовой станицы, в которой закодированы строки файла
    // </summary>
    // type:Integer
    property CodePage: Integer read FCodePage write SetCodePage;
    /// <summary>TMicromineImportService.Columns
    /// Определения колонок данных из файла
    /// </summary>
    /// type:TObjectList<TColumn>
    property Columns: TObjectList<TColumn> read FColumns;
    /// <summary>TMicromineImportService.FormatMarker
    /// Маркер формата файла (строка-заголовок из файла)
    /// </summary>
    /// type:string
    property FormatMarker: string read FFormatMarker write SetFormatMarker;
    /// <summary>TMicromineImportService.ImportContext
    /// Контекст операции импорта, передаваемый при создании сервиса
    /// </summary>
    /// type:TImportContext
    property ImportContext: TImportContext read FImportContext;
    /// <summary>TMicromineImportService.MetadataBytes
    /// Двоичные метаданные из файла
    /// </summary>
    /// type:TBytes
    property MetadataBytes: TBytes read FMetadataBytes write FMetadataBytes;
    /// <summary>TMicromineImportService.MetadataXml
    /// XML метаданые из файла
    /// </summary>
    /// type:string
    property MetadataXml: string read FMetadataXml write SetMetadataXml;
    /// <summary>TMicromineImportService.Rows
    /// Записи данных из файла
    /// </summary>
    /// type:TObjectList<TRow>
    property Rows: TObjectList<TRow> read FRows;
    /// <summary>TMicromineImportService.VariablesCount
    /// Количество колонок считанное из файла
    /// </summary>
    /// type:Integer
    property VariablesCount: Integer read FVariablesCount write
      SetVariablesCount;
  end;

implementation

uses
  DataConverters.ItemDataConverterFactoryUnit,
  DataConverters.ItemDataConverterUnit, Progress.NullProgressUnit,
  Log.NullLoggerUnit, VCL.Forms;

resourcestring
  SImportContextIsNil = 'Не задан контекст импорта AImportContext';
  SLoadCompleted = 'Загрузка завершена';
  SMarkerFormatFound = 'Маркер формата файла %s найден';
  SReadFormatMarker = 'Читаем маркер формата файла';
  SLoadingStarted = 'Начата загрузка из файла %s';
  SFileOpened = 'Файл %s открыт';
  SFileClosed = 'Файл %s закрыт';
  SReadingBinaryMethadata = 'Читаем двоичные метаданные';
  SBinaryMethadataSize = 'Объем двоичных метаданных %d байт';
  SXmlMethadataFound = 'XML метаданные найдены';
  SForXmlMethadataNotFound =
    'XML метаданные не найдены - вероятно "старый" формат файла';
  SLookForXmlMethadata = 'Поиск XML метаданных';
  SColumnDefenitionsReaded = 'Определения колонок данных прочитаны';
  SReadingColumnDefenitions = 'Читаем определения колонок данных';
  SColumnCountSpecified = 'Определено %d колонок данных';
  SMarkerNotFound = 'Не найден маркер %s';
  SReadingColumnCount = 'Читаем количество колонок данных';
  SReadingRows = 'Читаем строки данных';
  SRowsReaded = 'Строк данных прочитано %d';
  SMethadataSectionNotFound = 'Не найдена секция метаданных XML';
  SEndMarkerNotFound = 'Не найден маркер %s';
  SColumnDescriptorStringLess17Char =
    'Длина строки описания колонки данных менее 17 символов^ %s';
  SFileNotFound = 'Файл %s не найден';
  SInvalidFileHeader = 'Неверный заголовок файла %s';
  SInvalidColumnDataLength =
    'Неверная длина прочитанных данных для колонки $s строки %d';

const
  CColumnDisplayNameSeparator = '|';
  CColumnPrecisionSize = 3;
  CColumnDataLenSize = 3;
  CDataTypeIndex = 11;
  CColumnNameLen = 10;
  SVariablesMarker = 'VARIABLES';
  SMetadataEndMarker = '</metadata>';
  SFileHeaderMarker = 'THIS IS MICROMINE EXTENDED DATA FILE!'#$07#$1A#$01;

constructor TMicromineImportService.Create(AImportContext: TImportContext);
begin
  inherited Create;
  if AImportContext = nil then
    raise EArgumentException.Create(SImportContextIsNil);

  FCodePage := 1251;
  FColumns := TObjectList<TColumn>.Create();
  FRows := TObjectList<TRow>.Create();
  FImportContext := AImportContext;
end;

destructor TMicromineImportService.Destroy;
begin
  FRows.Free;
  FColumns.Free;
  inherited Destroy;
end;

procedure TMicromineImportService.AddLogInfo(AText: string; AParams: array of
  const);
begin
  FImportContext.FLogger.LogInfo(AText, AParams);
end;

procedure TMicromineImportService.AddRow(ARowBuffer: TBytes);
begin
  var vRow := TRow.Create;
  Rows.Add(vRow);

  var vStreamOfRow := TMemoryStream.Create();
  vStreamOfRow.WriteData(ARowBuffer, Length(ARowBuffer));
  vStreamOfRow.Seek(0, TSeekOrigin.soBeginning);

  for var I := 0 to Columns.Count - 1 do
    AddRowItem(vStreamOfRow, Columns[I], vRow);
end;

procedure TMicromineImportService.AddRowItem(AStreamOfRow: TStream; AColumn:
  TColumn; ARow: TRow);
begin
  var vItem := TRowItem.Create;
  ARow.Add(vItem);
  vItem.Column := AColumn;

  var vBuffer: TBytes := nil;
  SetLength(vBuffer, vItem.Column.Len);

  var vReadLen := AStreamOfRow.ReadData(vBuffer, AColumn.Len);
  if vReadLen < vItem.Column.Len then
    raise Exception.CreateFmt(SInvalidColumnDataLength, [AColumn.Name, AColumn.Len]);

  ConvertItemValueFromBytes(AColumn, ARow, vBuffer, vItem);
end;

function TMicromineImportService.BuffferEndsWithBytes(ABuffer, AEndMarker:
  TBytes): Boolean;
begin
  var vLen := Length(AEndMarker);
  Result := (Length(ABuffer) >= Length(AEndMarker)) and CompareMem(Pointer(Integer
    (ABuffer) + Length(ABuffer) - vLen), AEndMarker, vLen);
end;

procedure TMicromineImportService.ConvertItemValueFromBytes(AColumn: TColumn;
  ARow: TRow; vBuffer: TBytes; vItem: TRowItem);
begin
  var vContext := TDataConverterContext.Create;
  vContext.ABuffer := Copy(vBuffer, 0, Length(vBuffer));
  vContext.AColumn := AColumn;
  vContext.ARow := ARow;
  vContext.AItem := vItem;
  vContext.Encoding := Encoding;
  try
    var vDataConverter := TItemDataConverterFactory.CreateDataConverter(vContext);
    try
      vDataConverter.GetItemData(vContext);
    finally
      vDataConverter.Free;
    end;
  finally
    vContext.Free;
  end;
end;

function TMicromineImportService.Encoding: TEncoding;
begin
  Result := TEncoding.GetEncoding(CodePage);
end;

function TMicromineImportService.GetRowSize: LongInt;
begin
  Result := 0;
  for var vColumn in Columns do
    Inc(Result, vColumn.Len);

  // длина разделителя строк данных
  Inc(Result);
end;

procedure TMicromineImportService.ImportFromFile(AFileName: string);
begin
  if not TFile.Exists(AFileName) then
    raise EFileNotFoundException.CreateFmt(SFileNotFound, [AFileName]);

  AddLogInfo(SLoadingStarted, [AFileName]);

  var vFileStream := TBufferedFileStream.Create(AFileName, fmOpenRead);
  AddLogInfo(SFileOpened, [AFileName]);
  try
    ImportContext.CheckCancel;
    ReadFormatMarker(vFileStream);

    ImportContext.CheckCancel;
    if ReadMetadataXmlString(vFileStream) then
      ReadMetadataBytes(vFileStream);

    ImportContext.CheckCancel;
    ReadVariablesCount(vFileStream);

    ImportContext.CheckCancel;
    ReadColumns(vFileStream);

    ImportContext.CheckCancel;
    if vFileStream.Position < vFileStream.Size then
      ReadRows(vFileStream);
  finally
    vFileStream.Free;
    AddLogInfo(SFileClosed, [AFileName]);
  end;

  AddLogInfo(SLoadCompleted, []);
end;

procedure TMicromineImportService.ProcessAppMessages;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Application.ProcessMessages();
    end);
end;

procedure TMicromineImportService.ReadColumn(vFileStream: TBufferedFileStream);
begin
  var vColumnStr := ReadString(vFileStream);

  if vColumnStr.Length < 17 then
    raise Exception.CreateFmt(SColumnDescriptorStringLess17Char, [vColumnStr]);

  var vColumn := TColumn.Create;
  Columns.Add(vColumn);

  vColumn.Name := LeftStr(vColumnStr, CColumnNameLen).Trim();

  vColumn.DataType := TColumnDataType(AnsiIndexStr(vColumnStr[CDataTypeIndex],
    CColumnDataTypeChars));

  vColumn.Len := vColumnStr.Substring(CDataTypeIndex, CColumnDataLenSize)
    .Trim().ToInteger();

  vColumn.Precision := vColumnStr
    .Substring(CDataTypeIndex + CColumnDataLenSize, CColumnPrecisionSize)
    .Trim().ToInteger();

  if vColumnStr.Contains(CColumnDisplayNameSeparator) then
    vColumn.DisplayName := vColumnStr.Substring(vColumnStr
      .IndexOf(CColumnDisplayNameSeparator) + 1).Trim();
end;

procedure TMicromineImportService.ReadColumns(vFileStream: TBufferedFileStream);
var
  I: Integer;
begin
  AddLogInfo(SReadingColumnDefenitions, []);

  for I := 1 to VariablesCount do
    ReadColumn(vFileStream);

  AddLogInfo(SColumnDefenitionsReaded, []);
end;

procedure TMicromineImportService.ReadFormatMarker(vFileStream:
  TBufferedFileStream);
begin
  AddLogInfo(SReadFormatMarker, []);

  var vMarkerString := ReadString(vFileStream);
  if SFileHeaderMarker <> vMarkerString then
    raise Exception.CreateFmt(SInvalidFileHeader, [vMarkerString]);
  FFormatMarker := vMarkerString;

  AddLogInfo(SMarkerFormatFound, [FFormatMarker]);
  ShowProgresss(vFileStream);
end;

procedure TMicromineImportService.ReadMetadataBytes(vFileStream:
  TBufferedFileStream);
begin
  AddLogInfo(SReadingBinaryMethadata, []);

  var vEndBytes := Encoding.GetBytes(SVariablesMarker);
  var vBuffer := ReadSection(vFileStream, vEndBytes);

  if not BuffferEndsWithBytes(vBuffer, vEndBytes) then
    raise Exception.CreateFmt(SEndMarkerNotFound, [SVariablesMarker]);

  var vVarLen := Length(SVariablesMarker) + 4;

  FMetadataBytes := Copy(vBuffer, 0, Length(vBuffer) - vVarLen);

  AddLogInfo(SBinaryMethadataSize, [Length(FMetadataBytes)]);

  // вернем поток на начало маркера, для чтения его в начало следующей секции
  vFileStream.Seek(-vVarLen, TSeekOrigin.soCurrent);
end;

function TMicromineImportService.ReadMetadataXmlString(vFileStream:
  TBufferedFileStream): Boolean;
begin
  AddLogInfo(SLookForXmlMethadata, []);
  var vEndMarker := Encoding.GetBytes(SMetadataEndMarker);
  var vBuffer := ReadSection(vFileStream, vEndMarker);
  var vInitialPosition := vFileStream.Position;
  FMetadataXml := Encoding.GetString(vBuffer);
  Result := AnsiEndsText(SMetadataEndMarker, FMetadataXml);
  if not Result then
  begin
    vFileStream.Seek(vInitialPosition, TSeekOrigin.soBeginning);
    AddLogInfo(SForXmlMethadataNotFound, []);
  end
  else
    AddLogInfo(SXmlMethadataFound, []);
end;

procedure TMicromineImportService.ReadRows(vFileStream: TBufferedFileStream);
begin
  AddLogInfo(SReadingRows, []);

  var vRowSize: LongInt := GetRowSize();

  var vBuffer: TBytes := nil;
  SetLength(vBuffer, vRowSize);
  var vByte: Byte := 0;
  var vReadLen: LongInt := 0;
  repeat
    ImportContext.CheckCancel;

    vReadLen := vFileStream.ReadData(vBuffer, vRowSize);
    if vReadLen = vRowSize then
      AddRow(vBuffer);

    ShowProgresss(vFileStream);
    ProcessAppMessages();
  until vReadLen < vRowSize;

  AddLogInfo(SRowsReaded, [Rows.Count]);
end;

function TMicromineImportService.ReadSection(vFileStream: TBufferedFileStream;
  AEndMarker: TBytes): TBytes;
begin
  Result := nil;
  var vReadLen: LongInt := 0;
  var vByte: Byte := 0;
  repeat
    vReadLen := vFileStream.ReadData(vByte);
    Result := Result + [vByte];
    if BuffferEndsWithBytes(Result, AEndMarker) then
      Break;
  until vReadLen = 0;
end;

function TMicromineImportService.ReadString(vFileStream: TBufferedFileStream):
  string;
begin
  var vBuffer := ReadSection(vFileStream, [$0A]);
  Result := '';
  if Length(vBuffer) > 0 then
    Result := Encoding.GetString(vBuffer);
  Result := LeftStr(Result, Length(Result) - 1);
end;

procedure TMicromineImportService.ReadVariablesCount(vFileStream:
  TBufferedFileStream);
begin
  AddLogInfo(SReadingColumnCount, []);

  var vVarStr := ReadString(vFileStream);
  if not AnsiEndsText(SVariablesMarker, vVarStr) then
    raise Exception.CreateFmt(SMarkerNotFound, [SVariablesMarker]);
  VariablesCount := Trim(LeftStr(vVarStr, 4)).ToInteger;

  AddLogInfo(SColumnCountSpecified, [VariablesCount]);
end;

procedure TMicromineImportService.SetCodePage(const Value: Integer);
begin
  FCodePage := Value;
end;

procedure TMicromineImportService.SetFormatMarker(const Value: string);
begin
  FFormatMarker := Value;
end;

procedure TMicromineImportService.SetMetadataXml(const Value: string);
begin
  FMetadataXml := Value;
end;

procedure TMicromineImportService.SetVariablesCount(const Value: Integer);
begin
  FVariablesCount := Value;
end;

procedure TMicromineImportService.ShowProgresss(vFileStream: TBufferedFileStream);
begin
  FImportContext.FProgress.ShowPercent(100 * vFileStream.Position / vFileStream.Size)
end;

constructor TImportContext.Create(AProgress: IProgress; ALogger: ILogger; ATask:
  ITask);
begin
  inherited Create;
  FProgress := AProgress;
  FLogger := ALogger;

  if FLogger = nil then
    FLogger := TNullLogger.Create(lolInfo, nil);

  if FProgress = nil then
    FProgress := TNullProgress.Create;

  FTask := ATask;
end;

function TImportContext.CancellationPending: Boolean;
begin
  Result := (FTask <> nil) and (FTask.Status = TTaskStatus.Canceled);
end;

procedure TImportContext.CheckCancel;
begin
  if FTask <> nil then
    FTask.CheckCanceled;
end;

procedure TImportContext.SetTask(const Value: ITask);
begin
  FTask := Value;
end;

end.

