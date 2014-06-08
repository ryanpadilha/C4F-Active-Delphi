unit clUnidade;

interface

type
  TUnidade = class(TObject)
  private
    // métodos privados
    function getCodigo: String;
    function getDescricao: String;
    function getSigla: String;
    procedure setCodigo(const Value: String);
    procedure setDescricao(const Value: String);
    procedure setSigla(const Value: String);

    function Insert(): Boolean;
    function Update(): Boolean;

  protected
    // declaração de atributos
    _codigo: String;
    _descricao: String;
    _sigla: String;

  public
    // declaração das propriedades da classe, encapsulamento de atributos
    property Codigo: String read getCodigo write setCodigo;
    property Descricao: String read getDescricao write setDescricao;
    property Sigla: String read getSigla write setSigla;

    
    function Validar(): Boolean;
    function Merge(): Boolean;
    function Delete(): Boolean;
    function getObject(Id: String): Boolean;
    function getObjects(): Boolean;
    function getField(campo: String; coluna: String): String;

  end;

const
  TABLENAME = 'UNIDADE';

implementation

uses clUtil, dmConexao, SysUtils, Dialogs;

{ TUnidade }

function TUnidade.Delete: Boolean;
begin
  try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'DELETE FROM '+ TABLENAME +' WHERE UND_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Self.getCodigo;
      ExecSQL;
    end;

    Result := true;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TUnidade.getCodigo: String;
begin
  Result := _codigo;
end;

function TUnidade.getDescricao: String;
begin
  Result := _descricao;
end;

function TUnidade.getField(campo, coluna: String): String;
begin
  Try
    Result := '';

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT '+ campo +' FROM '+ TABLENAME;

      if coluna = 'DESCRICAO' then begin
        SQL.Add(' WHERE UND_DESCRICAO =:DESCRICAO ');
        ParamByName('DESCRICAO').AsString := Self.Descricao;
      end
      else if coluna = 'CODIGO' then begin
        SQL.Add(' WHERE UND_CODIGO =:CODIGO ');
        ParamByName('CODIGO').AsString := Self.Codigo;
      end
      else if coluna = 'SIGLA' then begin
        SQL.Add(' WHERE UND_SIGLA =:SIGLA');
        ParamByName('SIGLA').AsString := Self.Sigla;
      end;
      
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then
      Result := Conexao.QryGetObject.FieldByName(campo).AsString;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TUnidade.getObject(Id: String): Boolean;
begin
  try
    Result := False;

    if TUtil.Empty(Id) then
      Exit;

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' WHERE UND_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Id;
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then begin
      Self.Codigo := Conexao.QryGetObject.FieldByName('UND_CODIGO').AsString;
      Self.Descricao := Conexao.QryGetObject.FieldByName('UND_DESCRICAO').AsString;
      Self.Sigla := Conexao.QryGetObject.FieldByName('UND_SIGLA').AsString;

      Result := True;
    end
    else
      ShowMessage('Registro não encontrado!');
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TUnidade.getObjects: Boolean;
begin
  Try
    Result := False; 

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' ORDER BY UND_SIGLA';
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then
      Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TUnidade.getSigla: String;
begin
  Result := _sigla;
end;

function TUnidade.Insert: Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'INSERT INTO '+ TABLENAME +' (UND_DESCRICAO, UND_SIGLA) VALUES(:DESCRICAO, :SIGLA) ';
      ParamByName('DESCRICAO').AsString := Self.Descricao;
      ParamByName('SIGLA').AsString := Self.Sigla;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TUnidade.Merge: Boolean;
begin
  if TUtil.Empty(Self.Codigo) then
    Result := Self.Insert()
  else
    Result := Self.Update();
end;

procedure TUnidade.setCodigo(const Value: String);
begin
  _codigo := Trim(Value);
end;

procedure TUnidade.setDescricao(const Value: String);
begin
  _descricao := Trim(Value);
end;

procedure TUnidade.setSigla(const Value: String);
begin
  _sigla := Trim(Value);
end;

function TUnidade.Update: Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'UPDATE '+ TABLENAME +' SET UND_DESCRICAO =:DESCRICAO, UND_SIGLA =:SIGLA WHERE UND_CODIGO =:CODIGO ';                  
      ParamByName('DESCRICAO').AsString := Self.Descricao;
      ParamByName('SIGLA').AsString := Self.Sigla;
      ParamByName('CODIGO').AsString := Self.Codigo;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TUnidade.Validar: Boolean;
begin

  Result := True;
end;

end.
