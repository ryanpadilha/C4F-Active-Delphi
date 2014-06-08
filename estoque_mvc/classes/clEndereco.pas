unit clEndereco;

interface

type
  TEndereco = class(TObject)
  private
    function getBairro: String;
    function getCep: String;
    function getCodigo: String;
    function getComplemento: String;
    function getCorrespondencia: Boolean;
    function getLogradouro: String;
    function getNumero: String;
    function getReferencia: String;
    function getTipo: Integer;
    procedure setBairro(const Value: String);
    procedure setCep(const Value: String);
    procedure setCodigo(const Value: String);
    procedure setComplemento(const Value: String);
    procedure setCorrespondencia(const Value: Boolean);
    procedure setLogradouro(const Value: String);
    procedure setNumero(const Value: String);
    procedure setReferencia(const Value: String);
    procedure setTipo(const Value: Integer);
    function getCidade: String;
    procedure setCidade(const Value: String);

  protected
    // declaração de atributos
    _codigo: String;
    _logradouro: String;
    _numero: String;
    _complemento: String;
    _cep: String;
    _tipo: Integer;
    _correspondencia: Boolean;
    _referencia: String;
    _bairro: String;
    _cidade: String;

  public
    // declaração das propriedades da classe, encapsulamento de atributos
    property Codigo: String read getCodigo write setCodigo;
    property Logradouro: String read getLogradouro write setLogradouro;
    property Numero: String read getNumero write setNumero;
    property Complemento: String read getComplemento write setComplemento;
    property Cep: String read getCep write setCep;
    property Tipo: Integer read getTipo write setTipo;
    property Correspondencia: Boolean read getCorrespondencia write setCorrespondencia;
    property Referencia: String read getReferencia write setReferencia;
    property Bairro: String read getBairro write setBairro;
    property Cidade: String read getCidade write setCidade;
    // na linha acima antes do ponto e virgula (setCidade) pressione Ctrl + Shift + C
    // para gerar os métodos acessores getter e setter automaticamente

    // declaração de métodos
    function Validar(): Boolean;
    function Merge(): Boolean;
    function Delete(Filtro: String): Boolean;
    function getObject(Id: String; Filtro: String): Boolean;
    function Insert(Id: String; Tipo: String): Boolean;
    function Update(Id: String): Boolean;

  end;

const
  TABLENAME = 'ENDERECO';

implementation

uses SysUtils, Dialogs, dmConexao, clUtil;

{ TEndereco }

function TEndereco.Delete(Filtro: String): Boolean;
begin
  try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'DELETE FROM '+ TABLENAME +' WHERE END_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Self.Codigo;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEndereco.getBairro: String;
begin
  Result := _bairro;
end;

function TEndereco.getCep: String;
begin
  Result := _cep;
end;

function TEndereco.getCidade: String;
begin
  Result := _cidade;
end;

function TEndereco.getCodigo: String;
begin
  Result := _codigo;
end;

function TEndereco.getComplemento: String;
begin
  Result := _complemento;
end;

function TEndereco.getCorrespondencia: Boolean;
begin
  Result := _correspondencia;
end;

function TEndereco.getLogradouro: String;
begin
  Result := _logradouro;
end;

function TEndereco.getNumero: String;
begin
  Result := _numero;
end;

function TEndereco.getObject(Id, Filtro: String): Boolean;
begin
  Try
    Result := False;
  
    if TUtil.Empty(Id) then
      Exit;
    
    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM '+ TABLENAME);

      if filtro = 'ENDERECO' then begin
        SQL.Add(' WHERE END_CODIGO =:CODIGO');
        ParamByName('CODIGO').AsString := Id;
      end
      else if filtro = 'EMPRESA' then begin
        SQL.Add(' WHERE EMP_CODIGO =:CODIGO');
        ParamByName('CODIGO').AsString := Id;
      end;

      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then begin
      Self.Codigo := Conexao.QryGetObject.FieldByName('END_CODIGO').AsString;
      Self.Logradouro := Conexao.QryGetObject.FieldByName('END_LOGRADOURO').AsString;
      Self.Numero := Conexao.QryGetObject.FieldByName('END_NUMERO').AsString;
      Self.Complemento := Conexao.QryGetObject.FieldByName('END_COMPLEMENTO').AsString;
      Self.Bairro := Conexao.QryGetObject.FieldByName('END_BAIRRO').AsString;
      Self.Cidade := Conexao.QryGetObject.FieldByName('END_CIDADE').AsString;
      self.Cep := Conexao.QryGetObject.FieldByName('END_CEP').AsString;
      Self.Referencia := Conexao.QryGetObject.FieldByName('END_PT_REFERENCIA').AsString;
      Self.Tipo := Conexao.QryGetObject.FieldByName('END_TIPO').AsInteger;
      Self.Correspondencia := Conexao.QryGetObject.FieldByName('END_CORRESP').AsBoolean;
    
      Result := True;
    end
    else
      ShowMessage('Registro não encontrado!');
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEndereco.getReferencia: String;
begin
  Result := _referencia;
end;

function TEndereco.getTipo: Integer;
begin
  Result := _tipo;
end;

function TEndereco.Insert(Id, Tipo: String): Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'INSERT INTO '+ TABLENAME +' (END_LOGRADOURO, END_NUMERO, END_COMPLEMENTO, END_CEP, END_TIPO, '+
                  ' END_CORRESP, END_PT_REFERENCIA, END_BAIRRO, END_CIDADE, EMP_CODIGO) '+
                  '  VALUES(:LOGRADOURO, :NUMERO, :COMPLEMENTO, :CEP, :TIPO, :CORRESP, :REFERENCIA, :BAIRRO, :CIDADE, :EMPRESA) ';

      ParamByName('LOGRADOURO').AsString := Self.Logradouro;
      ParamByName('NUMERO').AsString := Self.Numero;
      ParamByName('COMPLEMENTO').AsString := Self.Complemento;
      ParamByName('CEP').AsString := Self.Cep;
      ParamByName('TIPO').AsInteger := Self.Tipo;
      ParamByName('CORRESP').AsBoolean := Self.Correspondencia;
      ParamByName('REFERENCIA').AsString := Self.Referencia;
      ParamByName('BAIRRO').AsString := Self.Bairro;
      ParamByName('CIDADE').AsString := Self.Cidade;

      if Tipo = 'EMPRESA' then
        ParamByName('EMPRESA').AsString := Id;

      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEndereco.Merge: Boolean;
begin
  // nada implementado aqui, INSERT e UPDATE executados diretamente
  // o modificador de acesso deste método pode ser definido como private!
  // ou sua declaração pode ser até mesmo removida,
  // não foi removida para manter a padronização de código.
  
  Result := False;
end;

procedure TEndereco.setBairro(const Value: String);
begin
  _bairro := Trim(Value);
end;

procedure TEndereco.setCep(const Value: String);
begin
  _cep := Trim(Value);
end;

procedure TEndereco.setCidade(const Value: String);
begin
  _cidade := Trim(Value);
end;

procedure TEndereco.setCodigo(const Value: String);
begin
  _codigo := Trim(Codigo);
end;

procedure TEndereco.setComplemento(const Value: String);
begin
  _complemento := Trim(Value);
end;

procedure TEndereco.setCorrespondencia(const Value: Boolean);
begin
  _correspondencia := Value;
end;

procedure TEndereco.setLogradouro(const Value: String);
begin
  _logradouro := Trim(Value);
end;

procedure TEndereco.setNumero(const Value: String);
begin
  _numero := Trim(Value);
end;

procedure TEndereco.setReferencia(const Value: String);
begin
  _referencia := Trim(Value);
end;

procedure TEndereco.setTipo(const Value: Integer);
begin
  _tipo := Value;
end;

function TEndereco.Update(Id: String): Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'UPDATE '+ TABLENAME +' SET END_LOGRADOURO =:LOGRADOURO, END_NUMERO =:NUMERO, '+
                  ' END_COMPLEMENTO =:COMPLEMENTO, END_CEP =:CEP, END_TIPO =:TIPO, END_CORRESP =:CORRESP, '+
                  ' END_PT_REFERENCIA =:REFERENCIA, END_BAIRRO =:BAIRRO, END_CIDADE =:CIDADE '+   
                  ' WHERE END_CODIGO =:CODIGO';
                  
      ParamByName('LOGRADOURO').AsString := Self.Logradouro;
      ParamByName('NUMERO').AsString := Self.Numero;
      ParamByName('COMPLEMENTO').AsString := Self.Complemento;
      ParamByName('BAIRRO').AsString := Self.Bairro;
      ParamByName('CIDADE').AsString := Self.Cidade;
      ParamByName('CEP').AsString := Self.Cep;
      ParamByName('REFERENCIA').AsString := Self.Referencia;
      ParamByName('TIPO').AsInteger := Self.Tipo;
      ParamByName('CORRESP').AsBoolean := Self.Correspondencia;
      ParamByName('CODIGO').AsString := Self.Codigo;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEndereco.Validar: Boolean;
begin
  // Na validação de dados podemos colocar qualquer atributo para ser validado
  // codigo abaixo deve ser customizado por cada leitor!

  Result := True;
end;

end.
