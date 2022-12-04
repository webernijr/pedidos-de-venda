unit uPedidoDadosGeraisModel;

interface

uses
  FireDAC.Comp.Client, uClienteModel, uPedidoProdutosController;

type
  TPedidoDadosGeraisModel = class
  private
    FNumeroPedido   : Integer;
    FDataEmissao    : TDateTime;
    FCliente        : TClienteModel;
    FValorTotal     : Currency;
    FPedidoProdutos : TPedidoProdutosController;
    FQuery          : TFDQuery;
    procedure Inserir();
    procedure Alterar();
    function RetornaUltimoNumeroPedido(): Integer;
  public
    property numeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property dataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property cliente: TClienteModel read FCliente write FCliente;
    property valotTotal: Currency read FValorTotal write FValorTotal;
    property pedidoProdutos: TPedidoProdutosController read FPedidoProdutos write FPedidoProdutos;
    property query: TFDQuery read FQuery write FQuery;

    constructor Create;
    destructor Destroy; override;

    procedure Gravar();
    procedure Carregar();
    procedure CarregarPedidoProdutos();
    procedure Deletar();
  end;

implementation

uses
  System.SysUtils, uFerramentasModel, uFerramentasController;

{ TPedidoDadosGeraisModel }

constructor TPedidoDadosGeraisModel.Create();
begin
  FPedidoProdutos := TPedidoProdutosController.Create();
  FCliente        := TClienteModel.Create();
  FQuery          := createQuery();
end;

destructor TPedidoDadosGeraisModel.Destroy;
begin
  FPedidoProdutos.Free;
  FCliente.Free;
  FQuery.Close;
  FQuery.Free;
  inherited;
end;

procedure TPedidoDadosGeraisModel.Gravar;
begin
  FQuery.Connection.StartTransaction;
  try
    if FNumeroPedido = 0 then
      Inserir()
    else
      Alterar();

    FPedidoProdutos.numeroPedido := FNumeroPedido;
    FPedidoProdutos.Gravar();
    FQuery.Connection.Commit;
  except on e:Exception do
    begin
      FQuery.Connection.Rollback;
      raise Exception.Create('Erro ao salvar pedido. ' + sLineBreak + 'Erro: '+e.Message);
    end;
  end;
end;

procedure TPedidoDadosGeraisModel.Inserir;
const
  sql = 'INSERT INTO pedidos_dados_gerais ' +
        ' (DATA_EMISSAO, CODIGO, VALOR_TOTAL) ' +
        ' VALUES ' +
        ' (:DATA_EMISSAO, :CODIGO, :VALOR_TOTAL)';
begin
  preparaQuerySQLAdd(FQuery, sql);
  FQuery.Params.ParamByName('DATA_EMISSAO').Value  := FDataEmissao;
  FQuery.Params.ParamByName('CODIGO').Value        := FCliente.codigo;
  FQuery.Params.ParamByName('VALOR_TOTAL').Value   := FValorTotal;
  FQuery.ExecSQL();

  FNumeroPedido := RetornaUltimoNumeroPedido();
end;

function TPedidoDadosGeraisModel.RetornaUltimoNumeroPedido():Integer;
const
  sql = 'SELECT NUMERO_PEDIDO ' +
        ' FROM pedidos_dados_gerais ' +
        ' ORDER BY NUMERO_PEDIDO desc ' +
        ' LIMIT 1';
begin
  preparaQueryOpen(FQuery, sql);
  Result := FQuery.FieldByName('NUMERO_PEDIDO').AsInteger;
end;

procedure TPedidoDadosGeraisModel.Alterar;
const
  sql = 'UPDATE pedidos_dados_gerais ' +
        ' SET DATA_EMISSAO = :DATA_EMISSAO, ' +
        '     CODIGO = :CODIGO, ' +
        '     VALOR_TOTAL = :VALOR_TOTAL ' +
        ' WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO';
begin
  preparaQuerySQLAdd(FQuery, sql);
  FQuery.Params.ParamByName('NUMERO_PEDIDO').Value := FNumeroPedido;
  FQuery.Params.ParamByName('DATA_EMISSAO').Value  := FDataEmissao;
  FQuery.Params.ParamByName('CODIGO').Value        := FCliente.codigo;
  FQuery.Params.ParamByName('VALOR_TOTAL').Value   := FValorTotal;
  FQuery.ExecSQL;
end;

procedure TPedidoDadosGeraisModel.carregar();
const
  sql = 'SELECT ' +
        '    NUMERO_PEDIDO, ' +
        '    DATA_EMISSAO, ' +
        '    CODIGO, ' +
        '    VALOR_TOTAL ' +
        ' FROM pedidos_dados_gerais ' +
        ' WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO ';
begin
  preparaQuerySQLAdd(FQuery, sql);
  FQuery.Params.ParamByName('NUMERO_PEDIDO').Value := FNumeroPedido;
  FQuery.Open;
  FNumeroPedido   := FQuery.FieldByName('NUMERO_PEDIDO').AsInteger;
  if FQuery.RecordCount = 0 then
    Exit;
  FDataEmissao    := FQuery.FieldByName('DATA_EMISSAO').AsDateTime;
  FCliente.codigo := FQuery.FieldByName('CODIGO').AsInteger;
  FValorTotal     := FQuery.FieldByName('VALOR_TOTAL').asCurrency;
  CarregarPedidoProdutos();
end;

procedure TPedidoDadosGeraisModel.CarregarPedidoProdutos;
const
  sql = 'SELECT ' +
        '     AUTOINCREM, ' +
        '     NUMERO_PEDIDO, ' +
        '     CODIGO, ' +
        '     QUANTIDADE, ' +
        '     VALOR_UNITARIO, ' +
        '     VALOR_UNITARIO ' +
        ' FROM pedidos_produtos ' +
        ' WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO ';
begin
  preparaQuerySQLAdd(FQuery, sql);
  FQuery.Params.ParamByName('NUMERO_PEDIDO').Value := FNumeroPedido;
  FQuery.Open;
end;

procedure TPedidoDadosGeraisModel.Deletar;
const
  sql = 'DELETE FROM pedidos_dados_gerais ' +
        ' WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO';
var
  qry : TFDQuery;
begin
  if FNumeroPedido = 0 then
    raise Exception.Create('Número do pedido não informado.');

  FQuery.Connection.StartTransaction;
  try
    preparaQuerySQLAdd(FQuery, sql);
    FQuery.Params.ParamByName('NUMERO_PEDIDO').Value := FNumeroPedido;
    FQuery.ExecSQL;

    FQuery.Connection.Commit;
  except on e:Exception do
    begin
      FQuery.Connection.Rollback;
      raise Exception.Create('Houve um erro ao deletar o Número do pedido informado. ' + sLineBreak + 'Erro: '+e.Message);
    end;
  end;

end;

end.
