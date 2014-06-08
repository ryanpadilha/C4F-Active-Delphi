unit clMarca;

interface

type
  TMarca = class(TObject)
  private
    // métodos privados
    function Insert(): Boolean;
    function Update(): Boolean;
    function getCodigo: String;
    function getDescricao: String;
    procedure setCodigo(const Value: String);
    procedure setDescricao(const Value: String);

  protected
    // declaração de atributos
    _codigo: String;
    _descricao: String;

  public
  
    // declaração das propriedades da classe, encapsulamento de atributos
    property Codigo: String read getCodigo write setCodigo;
    property Descricao: String read getDescricao write setDescricao;

    function Validar(): Boolean;
    function Merge(): Boolean;
    function Delete(): Boolean;
    function getObject(Id: String): Boolean;
    function getObjects(): Boolean;
    function getField(campo: String; coluna: String): String;

  end;

const
  TABLENAME = 'MARCA';

implementation

uses clUtil, dmConexao, SysUtils, Dialogs;

{ TMarca }

function TMarca.Delete: Boolean;
begin
  try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'DELETE FROM '+ TABLENAME +' WHERE MAR_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Self.getCodigo;
      ExecSQL;
    end;

    Result := true;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TMarca.getCodigo: String;
begin
  Result := _codigo;
end;

function TMarca.getDescricao: String;
begin
  Result := _descricao;
end;

function TMarca.getField(campo, coluna: String): String;
begin
  Try
    Result := '';

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT '+ campo +' FROM '+ TABLENAME;

      if coluna = 'DESCRICAO' then begin
        SQL.Add(' WHERE MAR_DESCRICAO =:DESCRICAO ');
        ParamByName('DESCRICAO').AsString := Self.Descricao;
      end
      else if coluna = 'CODIGO' then begin
        SQL.Add(' WHERE MAR_CODIGO =:CODIGO ');
        ParamByName('CODIGO').AsString := Self.Codigo;
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

function TMarca.getObject(Id: String): Boolean;
begin
  try
    Result := False;

    if TUtil.Empty(Id) then
      Exit;

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' WHERE MAR_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Id;
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then begin
      Self.Codigo := Conexao.QryGetObject.FieldByName('MAR_CODIGO').AsString;
      Self.Descricao := Conexao.QryGetObject.FieldByName('MAR_DESCRICAO').AsString;

      Result := True;
    end
    else
      ShowMessage('Registro não encontrado!');
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TMarca.getObjects: Boolean;
begin
  Try
    Result := False; 

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' ORDER BY MAR_DESCRICAO';
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

function TMarca.Insert: Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'INSERT INTO '+ TABLENAME +' (MAR_DESCRICAO) VALUES(:DESCRICAO) ';
      ParamByName('DESCRICAO').AsString := Self.Descricao;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TMarca.Merge: Boolean;
begin
  if TUtil.Empty(Self.Codigo) then
    Result := Self.Insert()
  else
    Result := Self.Update();
end;

procedure TMarca.setCodigo(const Value: String);
begin
  _codigo := Trim(Value);
end;

procedure TMarca.setDescricao(const Value: String);
begin
  _descricao := Trim(Value);
end;

function TMarca.Update: Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'UPDATE '+ TABLENAME +' SET MAR_DESCRICAO =:DESCRICAO WHERE MAR_CODIGO =:CODIGO ';                  
      ParamByName('DESCRICAO').AsString := Self.Descricao;
      ParamByName('CODIGO').AsString := Self.Codigo;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TMarca.Validar: Boolean;
begin

  Result := True;
end;

end.
