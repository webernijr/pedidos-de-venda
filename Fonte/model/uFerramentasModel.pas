unit uFerramentasModel;

interface

uses
  System.SysUtils, Vcl.Forms, udmWK, Winapi.Windows, FireDAC.Comp.Client, IniFiles;

  function conectar(): Boolean;
  function createQuery: TFDQuery;
  procedure preparaQuerySQLAdd(query: TFDQuery; sql: string);
  procedure preparaQueryOpen(query: TFDQuery; sql: string);
  function retornarDadosModel(tabela, campo, oondicao: string): string;
  function soNumero(Key: Char): Char;
  function soNumeroValor(Key: Char): Char;

implementation

function parametroConexao(): Boolean;
var
  arquivoINI: TIniFile;
  servidor,
  dataBase,
  usuario,
  senha,
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
      dataBase   := ArquivoINI.ReadString('PARAMETROS', 'DATABASE', '');
      usuario    := ArquivoINI.ReadString('PARAMETROS', 'USUARIO', 'root');
      senha      := ArquivoINI.ReadString('PARAMETROS', 'SENHA', '');
      ArquivoINI.Free;

      dmWK.Servidor := servidor;
      dmWK.DataBase := dataBase;
      dmWK.Usuario  := usuario;
      dmWK.Senha    := senha;
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

function soNumero(Key: Char): Char;
begin
  if not (Key in ['0'..'9', Chr(8)] ) then
    Key := #0;

  Result := Key;
end;

function soNumeroValor(Key: Char): Char;
begin
  if not (Key in ['0'..'9', Chr(8), ','] ) then
    Key := #0;

  Result := Key;
end;

end.
