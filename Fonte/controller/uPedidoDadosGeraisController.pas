unit uPedidoDadosGeraisController;

interface

uses
  FireDAC.Comp.Client, uPedidoDadosGeraisModel, uClienteController, uPedidoProdutosController;

type
  TPedidoDadosGeraisController = class
  private
    FNumeroPedido   : Integer;
    FDataEmissao    : TDateTime;
    FCliente        : TClienteCrontoller;
    FValorTotal     : Currency;
    FPedidoProdutos : TPedidoProdutosController;
    FQuery          : TFDQuery;
    procedure Validar();
  public
    property numeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property dataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property cliente: TClienteCrontoller read FCliente write FCliente;
    property valotTotal: Currency read FValorTotal write FValorTotal;
    property pedidoProdutos: TPedidoProdutosController read FPedidoProdutos write FPedidoProdutos;
    property query: TFDQuery read FQuery write FQuery;

    constructor Create;
    destructor Destroy; override;

    procedure Limpar();
    procedure Gravar();
    procedure Carregar();
    procedure Deletar();
  end;

implementation

uses
  System.SysUtils, uFerramentasModel, uFerramentasController;

{ TPedidoDadosGeraisController }

constructor TPedidoDadosGeraisController.Create();
begin
  FPedidoProdutos := TPedidoProdutosController.Create();
  FCliente        := TClienteCrontoller.Create();
  FQuery          := createQuery();
  Limpar();
end;

destructor TPedidoDadosGeraisController.Destroy;
begin
  FPedidoProdutos.Free;
  FCliente.Free;
  FQuery.Close;
  FQuery.Free;
  inherited;
end;

procedure TPedidoDadosGeraisController.Limpar();
begin
  FNumeroPedido := 0;
  FDataEmissao  := Now;
  FValorTotal   := 0;
  FPedidoProdutos.Limpar();
  FCliente.Limpar();
end;

procedure TPedidoDadosGeraisController.Gravar;
var
  pedidoDadosGeraisModel : TPedidoDadosGeraisModel;
begin
  pedidoDadosGeraisModel := TPedidoDadosGeraisModel.Create();
  try
    FCliente.Carregar;
    pedidoDadosGeraisModel.cliente.codigo       := FCliente.codigo;
    pedidoDadosGeraisModel.valotTotal           := FValorTotal;
    pedidoDadosGeraisModel.pedidoProdutos.itens := FPedidoProdutos.itens;
    pedidoDadosGeraisModel.Gravar;
  finally
    pedidoDadosGeraisModel.Free;
  end;
end;

procedure TPedidoDadosGeraisController.Validar();
begin
  if FValorTotal = 0 then
    raise Exception.Create('Valor Total não informado.');
  if FCliente.Codigo = 0 then
    raise Exception.Create('Cliente não informado.!');
  if FPedidoProdutos.itens.RecordCount = 0 then
    raise Exception.Create('Produto não informado.');
end;

procedure TPedidoDadosGeraisController.carregar();
var
  pedidoDadosGeraisModel : TPedidoDadosGeraisModel;
begin
  if FNumeroPedido = 0 then
    raise Exception.Create('Número do pedido não informado.');

  pedidoDadosGeraisModel := TPedidoDadosGeraisModel.Create;
  try
    pedidoDadosGeraisModel.numeroPedido := FNumeroPedido;
    pedidoDadosGeraisModel.Carregar;
    FNumeroPedido   := pedidoDadosGeraisModel.numeroPedido;
    FDataEmissao    := pedidoDadosGeraisModel.dataEmissao;
    FCliente.codigo := pedidoDadosGeraisModel.cliente.codigo;
    FValorTotal     := pedidoDadosGeraisModel.valotTotal;
    pedidoDadosGeraisModel.CarregarPedidoProdutos();
    FQuery          := pedidoDadosGeraisModel.query;
  finally
    //pedidoDadosGeraisModel.Free;
  end;
end;

procedure TPedidoDadosGeraisController.Deletar;
var
  pedidoDadosGeraisModel : TPedidoDadosGeraisModel;
begin
  if FNumeroPedido = 0 then
    raise Exception.Create('Número do pedido não informado.');

  pedidoDadosGeraisModel := TPedidoDadosGeraisModel.Create;
  try
    pedidoDadosGeraisModel.numeroPedido := FNumeroPedido;
    pedidoDadosGeraisModel.Carregar();
    if pedidoDadosGeraisModel.numeroPedido = 0 then
      raise Exception.Create('Pedido não localizado.');
    pedidoDadosGeraisModel.Deletar();
  finally
    pedidoDadosGeraisModel.Free;
  end;
end;

end.
