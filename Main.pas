unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TException = class
  private
    FLogFile: String;
  public
    constructor Create;
    // Tipo do parâmetro não pode ser alterado
    procedure GravarErroLog(erro: string);
    procedure TrataExecao(Sender: TObject; E: Exception);
  end;

  TfMain = class(TForm)
    btDatasetLoop: TButton;
    btThreads: TButton;
    btStreams: TButton;
    procedure btDatasetLoopClick(Sender: TObject);
    procedure btStreamsClick(Sender: TObject);
    procedure btThreadsClick(Sender: TObject);
  private
  public
  end;

var
  fMain: TfMain;

implementation

uses
  DatasetLoop, ClienteServidor, Threads;

{$R *.dfm}

constructor TException.Create;
begin
  FLogFile := ChangeFileExt(ParamStr(0), '.log');
  Application.onException := TrataExecao;
end;

procedure TfMain.btDatasetLoopClick(Sender: TObject);
begin
  fDatasetLoop.Show;
end;

procedure TfMain.btStreamsClick(Sender: TObject);
begin
  fClienteServidor.Show;
end;

procedure TfMain.btThreadsClick(Sender: TObject);
begin
  fThreads.Show;
end;

procedure TException.GravarErroLog(erro: string);

var
  Arq: TextFile;
begin
  AssignFile(Arq, ExtractFilePath(Application.ExeName) + '\aquivo.log');
  if not FileExists(ExtractFilePath(Application.ExeName) + '\aquivo.log') then
    Rewrite(Arq, ExtractFilePath(Application.ExeName) + '\aquivo.log');
  Append(Arq);
  Writeln(Arq, erro);
  Writeln(Arq, '');
  CloseFile(Arq);

end;

procedure TException.TrataExecao(Sender: TObject; E: Exception);

begin
  begin
    GravarErroLog('==================================');
    if TComponent(Sender) is TForm then
    begin
      GravarErroLog('Form: ' + TForm(Sender).Name);
      GravarErroLog('Caption: ' + TForm(Sender).Caption);
      GravarErroLog('Error: ' + E.ClassName);
      GravarErroLog('Error: ' + E.Message);
    end
    else
    begin
      GravarErroLog('Form: ' + TForm(TComponent(Sender).Owner).Name);
      GravarErroLog('Caption: ' + TForm(TComponent(Sender).Owner).Caption);
      GravarErroLog('Error: ' + E.ClassName);
      GravarErroLog('Error: ' + E.Message);
    end;
    GravarErroLog('===================================');
    Showmessage(E.Message);
  end;
end;

var
  FcooException: TException;

initialization

  ;
FcooException := TException.Create;

finalization

  ;
FcooException.Free;

end.
