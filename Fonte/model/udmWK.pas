unit udmWK;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.MySQL, Data.DB,
  FireDAC.Comp.Client, Data.FMTBcd, Data.SqlExpr, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdmWK = class(TDataModule)
    FDConnection: TFDConnection;
    MySQLDriverLink: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
  private
    FServidor : String;
    FDataBase : String;
    FUsuario  : String;
    FSenha    : String;
    procedure parametroConexao;
    { Private declarations }
  public
    property Servidor: String read FServidor write FServidor;
    property DataBase: String read FDataBase write FDataBase;
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read FSenha write FSenha;

    function conectar(): Boolean;
    { Public declarations }
  end;

var
  dmWK: TdmWK;

implementation

uses
  Vcl.Forms, Winapi.Windows;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmWK.parametroConexao();
begin
  FDConnection.Params.Clear;
  FDConnection.Params.Add('DriverID=MySQL');
  FDConnection.Params.Add('Database='+FDataBase);
  FDConnection.Params.Add('Server='+FServidor);
  FDConnection.Params.Add('User_Name='+FUsuario);
  FDConnection.Params.Add('Password='+FSenha);
end;

function TdmWK.conectar(): Boolean;
begin
  try
    parametroConexao();
    FDConnection.Connected := True;
  except on e:Exception do
    begin
      Application.MessageBox(Pchar('Erro ao estabelecer conexao com o servidor.' + sLineBreak), pchar(Application.Title), MB_ICONERROR+MB_OK);
    end;
  end;
  Result := FDConnection.Connected;
end;

end.
