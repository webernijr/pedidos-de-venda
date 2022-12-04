program WK;

uses
  Vcl.Forms,
  uformPedidoView in 'view\uformPedidoView.pas' {formPedidoView},
  udmWK in 'model\udmWK.pas' {dmWK: TDataModule},
  uFerramentasModel in 'model\uFerramentasModel.pas',
  uPedidoDadosGeraisController in 'controller\uPedidoDadosGeraisController.pas',
  uPedidoProdutosController in 'controller\uPedidoProdutosController.pas',
  uClienteController in 'controller\uClienteController.pas',
  uFerramentasController in 'controller\uFerramentasController.pas',
  uPedidoDadosGeraisModel in 'model\uPedidoDadosGeraisModel.pas',
  uClienteModel in 'model\uClienteModel.pas',
  uPedidoProdutosModel in 'model\uPedidoProdutosModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformPedidoView, formPedidoView);
  Application.CreateForm(TdmWK, dmWK);
  Application.Run;
end.
