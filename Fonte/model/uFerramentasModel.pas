unit uFerramentasModel;

interface

uses
  System.SysUtils, Vcl.Forms, udmWK, Winapi.Windows, FireDAC.Comp.Client;

  function conectar(): Boolean;
  function createQuery: TFDQuery;
  procedure preparaQuerySQLAdd(query: TFDQuery; sql: string);
  procedure preparaQueryOpen(query: TFDQuery; sql: string);
  function retornarDadosModel(tabela, campo, oondicao: string): string;

implementation

procedure parametroConexao();
begin
  dmWK.Servidor := 'localhost';
  dmWK.Usuario  := 'root';
  dmWK.Senha    := '';
end;

function conectar(): Boolean;
begin
  parametroConexao();
  Result := dmWK.conectar();
end;

function createQuery: TFDQuery;
begin
  Result            := TFDQuery.Create(nil);
  Result.Connection := dmWK.FDConnection;
end;

procedure preparaQuerySQLAdd(query: TFDQuery; sql: string);
begin
  query.Close;
  query.SQL.Clear;
  query.SQL.Add(sql);
end;

procedure preparaQueryOpen(query: TFDQuery; sql: string);
begin
  preparaQuerySQLAdd(query, sql);
  query.Open;
end;

function retornarDadosModel(tabela, campo, oondicao: string): string;
var
  query : TFDQuery;
  sql   : string;
begin
  sql   := 'SELECT ' + campo +
           ' FROM ' + tabela +
           ' WHERE ' + oondicao;
  query := createQuery();
  try
    preparaQueryOpen(query, sql);
    Result := query.FieldByName(campo).AsString;
  finally
    query.Free;
  end;

end;

end.
