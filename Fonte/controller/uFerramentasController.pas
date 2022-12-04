unit uFerramentasController;

interface

  function retornarDadosController(tabela, campo, oondicao: string): string;

implementation

uses
  uFerramentasModel;

function retornarDadosController(tabela, campo, oondicao: string): string;
begin
  Result := retornarDadosModel(tabela, campo, oondicao);
end;

end.
