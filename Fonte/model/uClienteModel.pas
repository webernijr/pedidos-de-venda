unit uClienteModel;

interface

uses
  FireDAC.Comp.Client;

type

  TClienteModel = class
  private
    FCodigo: Integer;
    FNome  : String;
    FCidade: string;
    FUF    : string;
    FQuery : TFDQuery;
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
  System.SysUtils, uFerramentasModel, uFerramentasController;

{ TClienteModel }

procedure TClienteModel.Carregar;
const
  sql = 'SELECT ' +
        '    CODIGO, ' +
        '    NOME, ' +
        '    CIDADE, ' +
        '    UF ' +
        ' FROM clientes ' +
        ' WHERE CODIGO = :CODIGO ';
begin
  if FCodigo = 0 then
    raise Exception.Create('Cliente não informado.');

  preparaQuerySQLAdd(FQuery, sql);
  FQuery.Params.ParamByName('CODIGO').Value := FCodigo;
  FQuery.Open;
  FCodigo := FQuery.FieldByName('CODIGO').AsInteger;
  if FQuery.RecordCount = 0 then
    Exit;
  FNome   := FQuery.FieldByName('NOME').AsString;
  FCidade := FQuery.FieldByName('CIDADE').AsString;
  FUF     := FQuery.FieldByName('UF').AsString;
end;

constructor TClienteModel.Create;
begin
  FQuery := createQuery();
  Limpar();
end;

destructor TClienteModel.Destroy;
begin
  FQuery.Close;
  FQuery.Free;

  inherited;
end;

procedure TClienteModel.Limpar;
begin
  FCodigo := 0;
  FNome   := '';
  FCidade := '';
  FUF     := '';
end;

end.
