unit uformPedidoView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uFerramentasModel, Vcl.ExtCtrls;

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
    FDMemTableC?digodoproduto: TIntegerField;
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
  private
    FValorTotal     : Currency;
    FidItemListagem : string;
    procedure ValidarDadosAdicionar();
    procedure PreencherGrid();
    procedure LimparCampos();
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
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formPedidoView: TformPedidoView;

implementation

uses
  uPedidoDadosGeraisController, uFerramentasController;

{$R *.dfm}

procedure TformPedidoView.buttonLimparClick(Sender: TObject);
begin
  LimparCampos();
  LiberarPedido();
end;

procedure TformPedidoView.buutonCarregarPedidoClick(Sender: TObject);
begin
  CarregarPedido();
  ValidarCamposCarregarPedido();
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
      editNumeroPedido.Clear;
      LimparGrid();
    end;
end;

procedure TformPedidoView.buttonCancelarPedidoClick(Sender: TObject);
begin
  DeletarPedido();
  editNumeroPedido.Clear;
end;

procedure TformPedidoView.buttonConfirmarClick(Sender: TObject);
begin
  ValidarDadosAdicionar;
  PreencherGrid;
  LimparCampos;
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
      raise Exception.Create('Cliente n?o foi informada.');
    end;
  if FDMemTable.RecordCount = 0 then
    raise Exception.Create('Nenhum produto adicionado ao pedido.');
  GravarPedido();
  Application.MessageBox('Pedido salvo!', PChar(Application.Title), MB_ICONINFORMATION+MB_OK);
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
begin
  pedidoDadosGeraisController := TPedidoDadosGeraisController.Create();
  try
    pedidoDadosGeraisController.cliente.codigo       := StrToIntDef(editCliente.Text, 0);
    pedidoDadosGeraisController.valotTotal           := FValorTotal;
    FDMemTable.First;
    pedidoDadosGeraisController.pedidoProdutos.itens := FDMemTable;
    pedidoDadosGeraisController.Gravar;
  finally
    pedidoDadosGeraisController.Free;
  end;
  LimparCampos();
  LimparGrid();
end;

procedure TformPedidoView.ValidarDadosAdicionar();
begin
  if StrToIntDef(editProduto.Text, 0) = 0 then
    begin
      editProduto.Clear;
      editProduto.SetFocus;
      raise Exception.Create('C?digo do produto n?o foi informado.');
    end;
  if StrToFloatDef(editQuantidade.Text, 0) = 0 then
    begin
      editQuantidade.Clear;
      editQuantidade.SetFocus;
      raise Exception.Create('Quantidade do produto n?o foi informado.');
    end;
  if StrToFloatDef(editValorUnitario.Text, 0) = 0 then
    begin
      editValorUnitario.Clear;
      editValorUnitario.SetFocus;
      raise Exception.Create('Valor unit?rio do produto n?o foi informado.');
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
    FDMemTable.FieldByName('valor_total').AsCurrency     := FDMemTable.FieldByName('quantidade').AsCurrency * FDMemTable.FieldByName('valor_unitario').AsCurrency;;
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
end;

procedure TformPedidoView.LimparGrid();
begin
  editCliente.Clear;
  FDMemTable.Close;
  FDMemTable.Open;
  FValorTotal := 0;
  labelValorTotalPedido.Caption := '0,00';
end;

procedure TformPedidoView.PrencherValorTotalPedido();
begin
  labelValorTotalPedido.Caption := FormatCurr('#,##0.00', FValorTotal);
end;

procedure TformPedidoView.DeletarRegistroListagem();
begin
  if Application.MessageBox('Deseja deletar o registro selecionado?', PChar(Application.Title), MB_YESNO+MB_ICONQUESTION) = ID_NO then
    Exit;
  FValorTotal := FValorTotal - FDMemTable.FieldByName('valor_total').AsCurrency;
  PrencherValorTotalPedido;
  FDMemTable.Delete;
end;

procedure TformPedidoView.editClienteChange(Sender: TObject);
begin
  validarCamposCarregarPedido();
end;

procedure TformPedidoView.editProdutoChange(Sender: TObject);
begin
  if StrToIntDef(editProduto.Text, 0) > 0 then
    editNomeProduto.Text := retornarDadosController('produtos', 'DESCRICAO', ' CODIGO = ' + editProduto.Text);
end;

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
  pedidoDadosGeraisController := TPedidoDadosGeraisController.Create();
  try
    pedidoDadosGeraisController.numeroPedido := StrToIntDef(editNumeroPedido.Text,0);
    pedidoDadosGeraisController.Carregar();
    if pedidoDadosGeraisController.numeroPedido = 0 then
      begin
        Application.MessageBox('Pedido n?o localizado.', PChar(Application.Title), MB_ICONINFORMATION+MB_OK);
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
                FDMemTable.FieldByName('valor_total').AsCurrency     := FDMemTable.FieldByName('quantidade').AsCurrency * FDMemTable.FieldByName('valor_unitario').AsCurrency;;
              end;
            FDMemTable.Post;
            FValorTotal := FValorTotal + FDMemTable.FieldByName('valor_total').AsCurrency;

            pedidoDadosGeraisController.query.Next;
          end;
        BloquearPedido();
        PrencherValorTotalPedido();
      end;
  finally
    pedidoDadosGeraisController.Free;
  end;
end;

procedure TformPedidoView.CarregarProdutoListagem();
begin
  FidItemListagem        := FDMemTable.FieldByName('id').asString;
  editProduto.Text       := FDMemTable.FieldByName('codigo_produto').asString;
  editQuantidade.Text    := FormatCurr('#,##0.00', FDMemTable.FieldByName('quantidade').asCurrency);
  editValorUnitario.Text := FormatCurr('#,##0.00', FDMemTable.FieldByName('valor_unitario').asCurrency);
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
  panelCarregarPedido.Visible := (buttonGravarPedido.Enabled = False) or ((buttonGravarPedido.Enabled = True) and (editCliente.Text = ''))
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
    Application.MessageBox('Pedido exclu?do.', PChar(Application.Title), MB_ICONINFORMATION+MB_OK);
  finally
    pedidoDadosGeraisController.Free;
  end;
end;

end.
