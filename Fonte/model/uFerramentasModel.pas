unit uFerramentasModel;

interface

uses
  System.SysUtils, Vcl.Forms, udmWK, Winapi.Windows, FireDAC.Comp.Client, IniFiles;

  function conectar(): Boolean;
  function createQuery: TFDQuery;
  procedure preparaQuerySQLAdd(query: TFDQuery; sql: string);
  procedure preparaQueryOpen(query: TFDQuery; sql: string);
  function retornarDadosModel(tabela, campo, oondicao: string): string;

implementation

function parametroConexao(): Boolean;
var
  arquivoINI: TIniFile;
  servidor,
  arquivo   : string;
begin
  Result  := True;
  arquivo := ExtractFilePath(Application.ExeName) + 'config.ini';

  if not FileExists(arquivo) then
      Result := False
  else
    begin
      ArquivoINI := TIniFile.Create(arquivo);
      servidor   := ArquivoINI.ReadString('PARAMETROS', 'SERVIDOR', 'localhost');
      ArquivoINI.Free;

      dmWK.Servidor := servidor;
      dmWK.Usuario  := 'root';
      dmWK.Senha    := '';
    end;
end;

function conectar(): Boolean;
begin
  if parametroConexao() then
    Result := dmWK.conectar()
  else
    begin
      Application.MessageBox('Atenção: Favor criar arquivo config.ini', PChar(Application.Title), MB_ICONINFORMATION+MB_OK);
      Exit;
    end;
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
