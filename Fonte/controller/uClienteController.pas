unit uClienteController;

interface

uses
  FireDAC.Comp.Client;

type

  TClienteCrontoller = class
  private
    FCodigo: Integer;
    FNome  : String;
    FCidade: string;
    FUF    : string;
    procedure Validar;
  public
    property codigo: Integer read FCodigo write FCodigo;
    property nome: String read FNome write FNome;
    property cidade: string read FCidade write FCidade;
    property uf : string read FUF write FUF;

    constructor Create;
    destructor Destroy; override;

    procedure Carregar();
    procedure Limpar();
  end;

implementation

uses
  System.SysUtils, uFerramentasController, uClienteModel;

{ TCliente }

procedure TClienteCrontoller.Carregar;
var
  clienteModel : TClienteModel;
begin
  clienteModel := TClienteModel.Create;
  try
    clienteModel.codigo := FCodigo;
    clienteModel.Carregar;

    FCodigo := clienteModel.codigo;

    Validar();

    FNome   := clienteModel.nome;
    FCidade := clienteModel.cidade;
    FUF     := clienteModel.uf;
  finally
    clienteModel.Free;
  end;
end;

procedure TClienteCrontoller.Validar();
begin
  if FCodigo = 0 then
    raise Exception.Create('Cliente inválido.');
end;

constructor TClienteCrontoller.Create;
begin
  Limpar();
end;

destructor TClienteCrontoller.Destroy;
begin

  inherited;
end;

procedure TClienteCrontoller.Limpar;
begin
  FCodigo := 0;
  FNome   := '';
  FCidade := '';
  FUF     := '';
end;

end.
