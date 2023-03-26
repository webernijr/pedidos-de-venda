unit uformPedidoView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uFerramentasModel, Vcl.ExtCtrls, System.Math;

type
  TformPedidoView = class(TForm)
    panelRodaPe: TPanel;
    labelValorTotal: TLabel;
    labelValorTotalPedido: TLabel;
    panelCampos: TPanel;
    labelCliente: TLabel;
    labelProduto: TLabel;
    labelQuantidade: TLabel;
    Label1: TLabel;
    editCliente: TEdit;
    editProduto: TEdit;
    editQuantidade: TEdit;
    editValorUnitario: TEdit;
    buttonConfirmar: TButton;
    buttonLimpar: TButton;
    buttonGravarPedido: TButton;
    Panel2: TPanel;
    DBGridListagemPedido: TDBGrid;
    FDMemTable: TFDMemTable;
    FDMemTableCódigodoproduto: TIntegerField;
    FDMemTabledescricao_produto: TStringField;
    FDMemTablequantidade: TCurrencyField;
    FDMemTablevalor_unitario: TCurrencyField;
    FDMemTablevalot_total: TCurrencyField;
    DataSource: TDataSource;
    buttonFechar: TButton;
    FDMemTableid: TStringField;
    panelCarregarPedido: TPanel;
    labelNumeroPedido: TLabel;
    editNumeroPedido: TEdit;
    buttonCancelarPedido: TButton;
    buutonCarregarPedido: TButton;
    labelNomeProduto: TLabel;
    editNomeProduto: TEdit;
    FDMemTableauto: TIntegerField;
    buttonCancelarLancamento: TButton;
    procedure buttonConfirmarClick(Sender: TObject);
    procedure DBGridListagemPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure buttonLimparClick(Sender: TObject);
    procedure buttonFecharClick(Sender: TObject);
    procedure editClienteChange(Sender: TObject);
    procedure buttonGravarPedidoClick(Sender: TObject);
    procedure buutonCarregarPedidoClick(Sender: TObject);
    procedure buttonCancelarPedidoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure editProdutoChange(Sender: TObject);
    procedure editValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure editQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure editValorUnitarioExit(Sender: TObject);
    procedure editQuantidadeExit(Sender: TObject);
    procedure buttonCancelarLancamentoClick(Sender: TObject);
    procedure editProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure editNumeroPedidoKeyPress(Sender: TObject; var Key: Char);
    procedure FDMemTablequantidadeSetText(Sender: TField; const Text: string);
  private
    FValorTotal     : Currency;
    FidItemListagem : string;
    procedure ValidarDadosAdicionar();
    procedure PreencherGrid();
    procedure LimparCampos();
    procedure LimparNumeroPedido();
    procedure LimparGrid();
    procedure PrencherValorTotalPedido();
    procedure DeletarRegistroListagem();
    procedure CarregarProdutoListagem();
    procedure BloquearCampoProduto();
    procedure LiberarCampoProduto();
    procedure ValidarCamposCarregarPedido();
    procedure GravarPedido();
    procedure CarregarPedido();
    procedure BloquearPedido();
    procedure LiberarPedido();
    procedure DeletarPedido;
    procedure liberarAlteracaoPedido;
    procedure LiberarCampoCliente;
    procedure BloquearCliente;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formPedidoView: TformPedidoView;

implementation

uses
  uPedidoDadosGeraisController, uFerramentasController, uPedidoProdutosController;

{$R *.dfm}

procedure TformPedidoView.buttonLimparClick(Sender: TObject);
begin
  LimparCampos();
  //LiberarPedido();
end;

procedure TformPedidoView.buutonCarregarPedidoClick(Sender: TObject);
begin
  CarregarPedido();
end;

procedure TformPedidoView.BloquearPedido;
begin
  buttonConfirmar.Enabled    := False;
  buttonGravarPedido.Enabled := False;
  editCliente.ReadOnly       := True;
  editCliente.ParentColor    := True;
end;

procedure TformPedidoView.LiberarPedido;
begin
  buttonConfirmar.Enabled    := True;
  buttonGravarPedido.Enabled := True;
  editCliente.ReadOnly       := False;
  editCliente.ParentColor    := False;
  editCliente.Color          := clWindow;
  if editNumeroPedido.Text <> '' then
    begin
      LimparNumeroPedido();
      LimparGrid();
    end;
end;

procedure TformPedidoView.buttonCancelarLancamentoClick(Sender: TObject);
begin
  LimparGrid();
  LimparCampos();
  LiberarPedido();
end;

procedure TformPedidoView.buttonCancelarPedidoClick(Sender: TObject);
begin
  DeletarPedido();
  LimparNumeroPedido();
end;

procedure TformPedidoView.buttonConfirmarClick(Sender: TObject);
begin
  ValidarDadosAdicionar;
  PreencherGrid;
  LimparCampos;
  editProduto.SetFocus;
end;

procedure TformPedidoView.buttonFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TformPedidoView.buttonGravarPedidoClick(Sender: TObject);
begin
  if StrToIntDef(editCliente.Text,0) = 0 then
    begin
      editCliente.SetFocus;
      raise Exception.Create('Cliente não foi informada.');
    end;
  if FDMemTable.RecordCount = 0 then
    raise Exception.Create('Nenhum produto adicionado ao pedido.');
  GravarPedido();
end;

procedure TformPedidoView.DBGridListagemPedidoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FDMemTable.RecordCount = 0 then
    Exit;
  case Key of
    VK_DELETE : DeletarRegistroListagem();
    VK_RETURN : CarregarProdutoListagem();
  end;
end;

procedure TformPedidoView.GravarPedido;
var
  pedidoDadosGeraisController : TPedidoDadosGeraisController;
  numeroPedido: string;
begin
  pedidoDadosGeraisController := TPedidoDadosGeraisController.Create();
  try
    if editNumeroPedido.Text <> '' then
      pedidoDadosGeraisController.numeroPedido       := StrToIntDef(editNumeroPedido.Text, 0);
    pedidoDadosGeraisController.cliente.codigo       := StrToIntDef(editCliente.Text, 0);
    pedidoDadosGeraisController.valotTotal           := FValorTotal;
    FDMemTable.First;
    pedidoDadosGeraisController.pedidoProdutos.itens := FDMemTable;
    numeroPedido := IntToStr(pedidoDadosGeraisController.Gravar());

    Application.MessageBox(PChar('Pedido salvo!' + #13 +
                                 'Número do pedido: ' + numeroPedido
                                ), PChar(Application.Title), MB_ICONINFORMATION+MB_OK);
  finally
    pedidoDadosGeraisController.Free;
  end;
  LimparGrid();
  LimparCampos();
  LimparNumeroPedido();
end;

procedure TformPedidoView.ValidarDadosAdicionar();
begin
  if StrToIntDef(editProduto.Text, 0) = 0 then
    begin
      editProduto.Clear;
      editProduto.SetFocus;
      raise Exception.Create('Código do produto não foi informado.');
    end;
  if StrToFloatDef(editQuantidade.Text, 0) = 0 then
    begin
      editQuantidade.Clear;
      editQuantidade.SetFocus;
      raise Exception.Create('Quantidade do produto não foi informado.');
    end;
  if StrToFloatDef(editValorUnitario.Text, 0) = 0 then
    begin
      editValorUnitario.Clear;
      editValorUnitario.SetFocus;
      raise Exception.Create('Valor unitário do produto não foi informado.');
    end;
end;

procedure TformPedidoView.PreencherGrid();
begin
  FDMemTable.DisableControls;
  try
    FDMemTable.Filtered := False;
    if FidItemListagem = '' then
      begin
        FDMemTable.Append;
        FDMemTable.FieldByName('id').AsString := FDMemTable.RecordCount.ToString;
      end
    else
      begin
        FDMemTable.Filter   := 'id = ' + FidItemListagem;
        FDMemTable.Filtered := True;
        FDMemTable.Edit;
        FValorTotal := FValorTotal - FDMemTable.FieldByName('valor_total').AsCurrency;
      end;
    FDMemTable.FieldByName('codigo_produto').asInteger   := StrToIntDef(editProduto.Text, 0);
    FDMemTable.FieldByName('descricao_produto').AsString := retornarDadosController('produtos', 'DESCRICAO', ' CODIGO = ' + FDMemTable.FieldByName('codigo_produto').AsString);
    FDMemTable.FieldByName('quantidade').AsCurrency      := StrToCurrDef(editQuantidade.Text, 0);
    FDMemTable.FieldByName('valor_unitario').AsCurrency  := StrToCurrDef(editValorUnitario.Text, 0);
    FDMemTable.FieldByName('valor_total').AsCurrency     := RoundTo(FDMemTable.FieldByName('quantidade').AsCurrency * FDMemTable.FieldByName('valor_unitario').AsCurrency, -2);
    FDMemTable.Post;
    FValorTotal := FValorTotal + FDMemTable.FieldByName('valor_total').AsCurrency;
  finally
    PrencherValorTotalPedido();
    FDMemTable.Filtered := False;
    FDMemTable.EnableControls;
    LiberarCampoProduto();
  end;
end;

procedure TformPedidoView.LimparCampos();
begin
  editProduto.Clear;
  editNomeProduto.Clear;
  editQuantidade.Clear;
  editValorUnitario.Clear;
  FidItemListagem := '';
  LiberarCampoProduto();
  LiberarCampoCliente();
  validarCamposCarregarPedido();
end;

procedure TformPedidoView.LimparGrid();
begin
  editCliente.Clear;
  FDMemTable.Close;
  FDMemTable.Open;
  FValorTotal := 0;
  labelValorTotalPedido.Caption := '0,00';
end;

procedure TformPedidoView.LimparNumeroPedido;
begin
  formPedidoView.Caption := 'Pedido de vendas';
  editNumeroPedido.Clear;
  LiberarCampoCliente();
end;

procedure TformPedidoView.PrencherValorTotalPedido();
begin
  labelValorTotalPedido.Caption := FormatCurr('###0.00', FValorTotal);
end;

procedure TformPedidoView.DeletarRegistroListagem();
var
  pedidoProdutoController : TPedidoProdutosController;
begin
  if Application.MessageBox('Deseja deletar o registro selecionado?', PChar(Application.Title), MB_YESNO+MB_ICONQUESTION) = ID_NO then
    Exit;

  if FDMemTable.FieldByName('auto').AsInteger <> 0 then
    begin
      pedidoProdutoController := TPedidoProdutosController.Create();
      try
        pedidoProdutoController.id := FDMemTable.FieldByName('auto').AsInteger;
        pedidoProdutoController.Deletar;
      finally
        pedidoProdutoController.Free;
      end;
    end;

  FValorTotal := FValorTotal - FDMemTable.FieldByName('valor_total').AsCurrency;
  PrencherValorTotalPedido;
  FDMemTable.Delete;
end;

procedure TformPedidoView.editClienteChange(Sender: TObject);
begin
  validarCamposCarregarPedido();
end;

procedure TformPedidoView.editNumeroPedidoKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := soNumero(Key);
end;

procedure TformPedidoView.editProdutoChange(Sender: TObject);
begin
  if StrToIntDef(editProduto.Text, 0) > 0 then
    editNomeProduto.Text := retornarDadosController('produtos', 'DESCRICAO', ' CODIGO = ' + editProduto.Text);
end;

procedure TformPedidoView.editProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  Key := soNumero(Key);
end;

procedure TformPedidoView.editQuantidadeExit(Sender: TObject);
begin
  if editQuantidade.Text <> '' then
    editQuantidade.Text := FormatCurr('###0.00', StrToCurr(editQuantidade.Text));
end;

procedure TformPedidoView.editQuantidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := soNumeroValor(Key);
end;

procedure TformPedidoView.editValorUnitarioExit(Sender: TObject);
begin
  if editValorUnitario.Text <> '' then
    editValorUnitario.Text := FormatCurr('###0.00', StrToCurr(editValorUnitario.Text));
end;

procedure TformPedidoView.editValorUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := soNumeroValor(Key);
end;

procedure TformPedidoView.FDMemTablequantidadeSetText(Sender: TField;
  const Text: string);
begin
  ShowMessage(Text)end;

procedure TformPedidoView.FormShow(Sender: TObject);
begin
  if conectar() then
    begin
      FDMemTable.Open;
      FValorTotal     := 0;
      FidItemListagem := '';
    end
  else
    Close;
end;

procedure TformPedidoView.CarregarPedido();
var
  pedidoDadosGeraisController : TPedidoDadosGeraisController;
  i : Integer;
begin
  formPedidoView.Caption := 'Pedido de vendas -> Número: ' + editNumeroPedido.Text;
  pedidoDadosGeraisController := TPedidoDadosGeraisController.Create();
  try
    pedidoDadosGeraisController.numeroPedido := StrToIntDef(editNumeroPedido.Text,0);
    pedidoDadosGeraisController.Carregar();
    if pedidoDadosGeraisController.numeroPedido = 0 then
      begin
        Application.MessageBox('Pedido não localizado.', PChar(Application.Title), MB_ICONINFORMATION+MB_OK);
      end
    else
      begin
        editCliente.Text := pedidoDadosGeraisController.cliente.Codigo.ToString;
        FDMemTable.Close;
        FDMemTable.Open;
        pedidoDadosGeraisController.query.First;
        while not pedidoDadosGeraisController.query.Eof do
          begin
            FDMemTable.Append;
            with pedidoDadosGeraisController.query do
              begin
                FDMemTable.FieldByName('id').AsInteger               := FieldByName('AUTOINCREM').AsInteger;
                FDMemTable.FieldByName('codigo_produto').asInteger   := FieldByName('CODIGO').AsInteger;
                FDMemTable.FieldByName('descricao_produto').AsString := retornarDadosController('produtos', 'DESCRICAO', ' CODIGO = ' + FDMemTable.FieldByName('codigo_produto').AsString);
                FDMemTable.FieldByName('quantidade').AsCurrency      := FieldByName('QUANTIDADE').AsCurrency;;
                FDMemTable.FieldByName('valor_unitario').AsCurrency  := FieldByName('VALOR_UNITARIO').AsCurrency;
                FDMemTable.FieldByName('valor_total').AsCurrency     := FieldByName('VALOR_TOTAL').AsCurrency;
                //FDMemTable.FieldByName('valor_total').AsCurrency     := FDMemTable.FieldByName('quantidade').AsCurrency * FDMemTable.FieldByName('valor_unitario').AsCurrency;;
                FDMemTable.FieldByName('auto').AsInteger             := FieldByName('AUTOINCREM').AsInteger;
              end;
            FDMemTable.Post;
            FValorTotal := FValorTotal + FDMemTable.FieldByName('valor_total').AsCurrency;

            pedidoDadosGeraisController.query.Next;
          end;
        BloquearCliente();
        PrencherValorTotalPedido();
      end;
  finally
    pedidoDadosGeraisController.Free;
  end;
end;

procedure TformPedidoView.CarregarProdutoListagem();
begin
  panelCarregarPedido.Visible := False;
  FidItemListagem        := FDMemTable.FieldByName('id').asString;
  editProduto.Text       := FDMemTable.FieldByName('codigo_produto').asString;
  editQuantidade.Text    := FormatCurr('###0.00', FDMemTable.FieldByName('quantidade').asCurrency);
  editValorUnitario.Text := FormatCurr('###0.00', FDMemTable.FieldByName('valor_unitario').asCurrency);
  liberarAlteracaoPedido();
  bloquearCampoProduto();
end;

procedure TformPedidoView.BloquearCampoProduto();
begin
  editProduto.ReadOnly    := True;
  editProduto.ParentColor := True;
end;

procedure TformPedidoView.LiberarCampoProduto();
begin
  editProduto.ReadOnly    := False;
  editProduto.ParentColor := False;
  editProduto.Color       := clWindow;
end;

procedure TformPedidoView.ValidarCamposCarregarPedido();
begin
  panelCarregarPedido.Visible := (editCliente.Text = '') And (FDMemTable.RecordCount = 0);
end;

procedure TformPedidoView.DeletarPedido();
var
  pedidoDadosGeraisController : TPedidoDadosGeraisController;
begin
  pedidoDadosGeraisController := TPedidoDadosGeraisController.Create;
  try
    pedidoDadosGeraisController.numeroPedido := StrToIntDef(editNumeroPedido.Text,0);
    pedidoDadosGeraisController.Deletar();
    LiberarCampoProduto();
    LiberarPedido();
    ValidarCamposCarregarPedido();
    Application.MessageBox('Pedido excluído.', PChar(Application.Title), MB_ICONINFORMATION+MB_OK);
  finally
    pedidoDadosGeraisController.Free;
  end;
end;

procedure TformPedidoView.liberarAlteracaoPedido;
begin
  buttonConfirmar.Enabled    := True;
  buttonGravarPedido.Enabled := True;
end;

procedure TformPedidoView.LiberarCampoCliente();
begin
  if editNumeroPedido.Text = '' then
    begin
      editCliente.ReadOnly    := False;
      editCliente.ParentColor := False;
      editCliente.Color       := clWindow;
    end;
end;

procedure TformPedidoView.BloquearCliente;
begin
  editCliente.ReadOnly       := True;
  editCliente.ParentColor    := True;
end;

end.
