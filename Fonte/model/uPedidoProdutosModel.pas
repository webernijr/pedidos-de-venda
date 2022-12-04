unit uPedidoProdutosModel;

interface

uses
  FireDAC.Comp.Client, uFerramentasModel;

type
  TPedidoProdutosModel = class
  private
    FId            : Integer;
    FNumeroPedido  : Integer;
    FCodigo        : Integer;
    FQuantidade    : Currency;
    FValorUnitario : Currency;
    FValorTotal    : Currency;
    FQuery         : TFDQuery;
  public
    constructor Create();
    destructor Destroy(); override;
    property id: Integer read FId write FId;
    property numeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property codigo: Integer read FCodigo write FCodigo;
    property quantidade: Currency read FQuantidade write FQuantidade;
    property valorUnitario: Currency read FValorUnitario write FValorUnitario;
    property valorToTal: Currency read FValorToTal write FValorToTal;
    procedure Inserir();
  end;
implementation

uses
  System.SysUtils, uFerramentasController;

{ TPedidoProdutosModel }

constructor TPedidoProdutosModel.Create();
begin
  FQuery := createQuery();
end;

destructor TPedidoProdutosModel.Destroy();
begin
  FQuery.Close;
  FQuery.Free;

  inherited;
end;

procedure TPedidoProdutosModel.Inserir();
const
  sql  = 'INSERT INTO pedidos_produtos ' +
         ' (NUMERO_PEDIDO, CODIGO, QUANTIDADE, VALOR_UNITARIO, VALOR_TOTAL) ' +
         ' VALUES ' +
         '(:NUMERO_PEDIDO, :CODIGO, :QUANTIDADE, :VALOR_UNITARIO, :VALOR_TOTAL)';
begin
  preparaQuerySQLAdd(FQuery, sql);
  FQuery.Params.ParamByName('NUMERO_PEDIDO').Value  := FNumeroPedido;
  FQuery.Params.ParamByName('CODIGO').Value         := FCodigo;
  FQuery.Params.ParamByName('QUANTIDADE').Value     := FQuantidade;
  FQuery.Params.ParamByName('VALOR_UNITARIO').Value := FValorUnitario;
  FQuery.Params.ParamByName('VALOR_TOTAL').Value    := FValorToTal;
  FQuery.ExecSQL;
end;

end.

