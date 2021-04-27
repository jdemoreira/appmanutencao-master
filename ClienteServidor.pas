unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Threading,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Datasnap.DBClient, Data.DB;

type
  TServidor = class
  private
    FPath: string;
    FSequencia: Integer;

  public
    constructor Create;
    // Tipo do parâmetro não pode ser alterado
    function SalvarArquivos(AData: OleVariant): Boolean;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure EnviarParalelo;
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure btEnviarParaleloClick(Sender: TObject);
  private
    FPath: string;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
 FServidor.FSequencia := 0;
  cds := InitDataset;
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
  {  cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
    cds.Post;}

    {$REGION Simulação de erro, não alterar}
    if i = (QTD_ARQUIVOS_ENVIAR/2) then
      FServidor.SalvarArquivos(NULL);
    {$ENDREGION}
  end;

  FServidor.SalvarArquivos(cds.Data);

end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
var
  Task: ITask;
begin
  Task := TTask.Create(EnviarParalelo);
  Task.Start;
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;

begin

  ProgressBar.Position := 0;
  FServidor.FSequencia := 0;

  ProgressBar.Max := 100;
  cds := InitDataset;
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin

    cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);

    cds.Post;

    if cds.RecordCount = 5 then
    begin
      FServidor.SalvarArquivos(cds.Data);

      cds.EmptyDataSet;
    end;

    ProgressBar.Position := i;

    Sleep(25);
  end;

  FServidor.SalvarArquivos(cds.Data);

end;

procedure TfClienteServidor.EnviarParalelo;
var
  cds: TClientDataset;
  i: Integer;

begin

  ProgressBar.Position := 0;
  FServidor.FSequencia := 0;

  ProgressBar.Max := 100;
  cds := InitDataset;
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin

    cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);

    cds.Post;

    if cds.RecordCount = 5 then
    begin
      FServidor.SalvarArquivos(cds.Data);

      cds.EmptyDataSet;
    end;

    ProgressBar.Position := i;

  end;

  FServidor.SalvarArquivos(cds.Data);

end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
{$WARN SYMBOL_PLATFORM OFF}
  FPath := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
{$WARN SYMBOL_PLATFORM ON}
  FServidor := TServidor.Create;
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataset;
  FileName: string;
  listaArquivo: tstrings;
  i: Integer;
begin

  Result := False;

  if AData = null then
    cds := fClienteServidor.InitDataset
  else
  begin
    cds := TClientDataset.Create(nil);
    cds.Data := AData;

  end;

{$REGION Simulação de erro, não alterar}
  if cds.RecordCount = 0 then
    Exit;
{$ENDREGION}
  cds.First;
  listaArquivo := tstringlist.Create;
  while not cds.Eof do
  begin
    try
      FileName := FPath + FSequencia.ToString + '.pdf';
      TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
      listaArquivo.Add(FileName);
      inc(FSequencia);
    except
      begin
        for i := 0 to listaArquivo.count - 1 do
          if TFile.Exists(listaArquivo[i]) then
            TFile.Delete(listaArquivo[i]);
        listaArquivo.free;
        raise Exception.Create('Error na gravação.');
      end;

    end;

    cds.Next;
  end;

  Result := True;
  cds.free;
  listaArquivo.free;
end;

end.
