unit uPedidoProdutosController;

interface

uses
  FireDAC.Comp.Client, uPedidoProdutosModel;

type
  TPedidoProdutosController = class
  private
    FId            : Integer;
    FNumeroPedido  : Integer;
    FCodigo        : Integer;
    FQuantidade    : Currency;
    FValorUnitario : Currency;
    FValorTotal    : Currency;
    FQuery         : TFDQuery;
    FItens         : TFDMemTable;
    procedure Validar();
  public
    constructor Create();
    destructor Destroy(); override;
    property id: Integer read FId write FId;
    property numeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property codigo: Integer read FCodigo write FCodigo;
    property quantidade: Currency read FQuantidade write FQuantidade;
    property valorUnitario: Currency read FValorUnitario write FValorUnitario;
    property valorToTal: Currency read FValorToTal write FValorToTal;
    property itens: TFDMemTable read FItens write FItens;
    procedure Gravar();
    procedure Limpar();
  end;
implementation

uses
  System.SysUtils, uFerramentasController;

{ TPedidoProdutosController }

constructor TPedidoProdutosController.Create();
begin
  Limpar();
end;

destructor TPedidoProdutosController.Destroy();
begin

  inherited;
end;

procedure TPedidoProdutosController.Limpar();
begin
  FId            := 0;
  FNumeroPedido  := 0;
  FCodigo        := 0;
  FQuantidade    := 0;
  FValorUnitario := 0;
  FValorToTal    := 0;
end;

procedure TPedidoProdutosController.Validar();
begin
  if FNumeroPedido = 0 then
    raise Exception.Create('Número do pedido não informado.');
  if FCodigo = 0 then
    raise Exception.Create('Produto não informado.');
  if FQuantidade = 0 then
    raise Exception.Create('Quantidade não informado.');
  if FValorUnitario = 0 then
    raise Exception.Create('Valor unitário não informado.');
  if FValorToTal = 0 then
    raise Exception.Create('Valor toral não informado.');
end;

procedure TPedidoProdutosController.Gravar();
var
  pedidoProdutoModel : TPedidoProdutosModel;
begin

  while not itens.Eof do
    begin
      FCodigo        := itens.FieldByName('codigo_produto').AsInteger;
      FQuantidade    := itens.FieldByName('quantidade').AsCurrency;
      FValorUnitario := itens.FieldByName('valor_unitario').AsCurrency;
      FValorTotal    := itens.FieldByName('valor_total').AsCurrency;

      Validar;

      if FId = 0 then
        begin
          pedidoProdutoModel := TPedidoProdutosModel.Create;
          try
            pedidoProdutoModel.numeroPedido  := FNumeroPedido;
            pedidoProdutoModel.codigo        := FCodigo;
            pedidoProdutoModel.quantidade    := FQuantidade;
            pedidoProdutoModel.valorUnitario := FValorUnitario;
            pedidoProdutoModel.valorToTal    := FValorTotal;

            pedidoProdutoModel.Inserir;
          finally
            pedidoProdutoModel.Free;
          end;

        end;

      itens.Next;
    end;
end;

end.
