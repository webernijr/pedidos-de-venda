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
    procedure Inserir();
    procedure Alterar();
  public
    constructor Create();
    destructor Destroy(); override;
    property id: Integer read FId write FId;
    property numeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property codigo: Integer read FCodigo write FCodigo;
    property quantidade: Currency read FQuantidade write FQuantidade;
    property valorUnitario: Currency read FValorUnitario write FValorUnitario;
    property valorToTal: Currency read FValorToTal write FValorToTal;

    procedure Gravar;
    procedure Deletar;
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

procedure TPedidoProdutosModel.Alterar;
const
  sql = 'UPDATE pedidos_produtos ' +
        ' SET QUANTIDADE = :QUANTIDADE, ' +
        '     VALOR_UNITARIO = :VALOR_UNITARIO, ' +
        '     VALOR_TOTAL = :VALOR_TOTAL ' +
        ' WHERE AUTOINCREM = :AUTOINCREM';
begin
  preparaQuerySQLAdd(FQuery, sql);
  FQuery.Params.ParamByName('AUTOINCREM').Value     := FId;
  FQuery.Params.ParamByName('QUANTIDADE').Value     := FQuantidade;
  FQuery.Params.ParamByName('VALOR_UNITARIO').Value := FValorUnitario;
  FQuery.Params.ParamByName('VALOR_TOTAL').Value    := FValorTotal;
  FQuery.ExecSQL;
end;

procedure TPedidoProdutosModel.Gravar;
begin
  FQuery.Connection.StartTransaction;
  try
    if FId = 0 then
      Inserir()
    else
      Alterar();

    FQuery.Connection.Commit;
  except on e:Exception do
    begin
      FQuery.Connection.Rollback;
      raise Exception.Create('Erro ao salvar produto. ' + sLineBreak + 'Erro: '+e.Message);
    end;
  end;
end;

procedure TPedidoProdutosModel.Deletar;
const
  sql = 'DELETE FROM pedidos_produtos ' +
        ' WHERE AUTOINCREM = :AUTOINCREM';
var
  qry : TFDQuery;
begin
  if FId = 0 then
    raise Exception.Create('Produto não informado.');

  FQuery.Connection.StartTransaction;
  try
    preparaQuerySQLAdd(FQuery, sql);
    FQuery.Params.ParamByName('AUTOINCREM').Value := FId;
    FQuery.ExecSQL;

    FQuery.Connection.Commit;
  except on e:Exception do
    begin
      FQuery.Connection.Rollback;
      raise Exception.Create('Houve um erro ao deletar o Produto informado. ' + sLineBreak + 'Erro: '+e.Message);
    end;
  end;

end;

end.

