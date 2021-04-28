unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TProcesso = class(TThread)
  private
    FAux: String;
    FMemo: TMemo;
    Ftempo: Integer;
    FProgressBar: TProgressBar;
  public
    constructor Create(AMemo: TMemo; AProgressBar: TProgressBar;
      ATempo: Integer); reintroduce;
    procedure Execute; override;
    procedure Sincronizar;
  end;

type
  TfThreads = class(TForm)
    edtNumTheads: TEdit;
    edtTempo: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    FProcesso: Array of TProcesso;

  public
    { Public declarations }

  end;

var
  fThreads: TfThreads;

implementation

{$R *.dfm}

constructor TProcesso.Create;
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;

  FAux := '';
  FMemo := AMemo;
  Ftempo := ATempo;
  FProgressBar := AProgressBar;
end;

procedure TProcesso.Execute;
var
  I: Integer;
  int: Integer;
begin
  FProgressBar.Position := 0;
  FProgressBar.Max := 100;
  I := 0;
  int := Random(Ftempo);
  Self.FAux := IntToStr(int) + ' – Iniciando processamento';
  FMemo.Lines.Add(Self.FAux);
  while I <= 100 do
  begin
    I := I + 1;

    FProgressBar.Position := I;
  end;
  Self.FAux := IntToStr(int) + ' – Processamento finalizado';
  FMemo.Lines.Add(Self.FAux);
  FreeOnTerminate := false;
  Free;
end;

procedure TProcesso.Sincronizar;
begin
end;
{ TfThreads }

procedure TfThreads.Button1Click(Sender: TObject);
var
  I: Integer;

begin
  if edtNumTheads.Text = '' then
    raise Exception.Create('Favor Informar a quantidade de Theads');
  if edtTempo.Text = '' then
    raise Exception.Create('Favor Informar o tempo.');

  SetLength(FProcesso, 0);
  SetLength(FProcesso, StrToInt(edtNumTheads.Text));
  for I := 1 to StrToInt(edtNumTheads.Text) do
  begin
    // Determinando o tamanho do array.
    FProcesso[I] := TProcesso.Create(Memo1, ProgressBar1,
      StrToInt(edtTempo.Text));

    FProcesso[I].Start;
    FProcesso[I].FreeOnTerminate := True;
    Sleep(StrToInt(edtTempo.Text));
  end;

end;

procedure TfThreads.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  if edtNumTheads.Text <> '' then
  begin
    for I := 1 to StrToInt(edtNumTheads.Text) do
      if FProcesso[I].FreeOnTerminate then
        raise Exception.Create('Processo não finalizado favor aguarde.');
  end;
end;

end.
