unit clEmpresa;

interface

uses clPessoaJ, clEndereco;

type
  TEmpresa = class(TPessoaJ)
  private
    // métodos privados
    function Insert(): Boolean;
    function Update(): Boolean;
    function getCodigo: String;
    procedure setCodigo(const Value: String);



  protected
    // declaração de atributos
    _codigo: String;
    
  public
    // método contrutor definido por nós
    constructor Create;

    // declaração das propriedades da classe, encapsulamento de atributos
    property Codigo: String read getCodigo write setCodigo;

    // métodos públicos
    function Validar(): Boolean;
    function Merge(): Boolean;
    function Delete(): Boolean;
    function getObject(Id: String): Boolean;
    procedure getMaxId;
    function getObjects: Boolean;
    function getField(campo, coluna: String): String;

  end;

const
  TABLENAME = 'EMPRESA';

implementation

uses SysUtils, clPessoa, clUtil, dmConexao, DB, ZDataset, ZAbstractRODataset, Math, Dialogs;

{ TEmpresa }

constructor TEmpresa.Create;
begin
  _endereco := TEndereco.Create;
end;

function TEmpresa.getField(campo, coluna: String): String;
begin
  Try
    Result := '';

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT '+ campo +' FROM '+ TABLENAME;

      if coluna = 'RAZAO' then begin
        SQL.Add(' WHERE EMP_RAZAO =:RAZAO ');
        ParamByName('RAZAO').AsString := Self.Razao;
      end
      else if coluna = 'FANTASIA' then begin
        SQL.Add(' WHERE EMP_FANTASIA =:FANTASIA ');
        ParamByName('FANTASIA').AsString := Self.Fantasia;
      end
      else if coluna = 'CODIGO' then begin
        SQL.Add(' WHERE EMP_CODIGO =:CODIGO ');
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

function TEmpresa.Delete: Boolean;
begin
  Try
    Result := False;

    // deletar registros filhos
    if NOT Self.Endereco.Delete(Self.Endereco.Codigo) then begin
      ShowMessage('erro ao deletar endereco'); // mensagem temporaria, melhor controle de transacao
      // deletar registro da empresa, pois houve erro ao inserir empresa
      Result := False;
    end;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'DELETE FROM '+ TABLENAME +' WHERE EMP_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Self.Codigo;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEmpresa.getCodigo: String;
begin
  Result := _codigo;
end;

procedure TEmpresa.getMaxId;
begin
  Try
    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT MAX(EMP_CODIGO) AS CODIGO FROM '+ TABLENAME;
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then
      Self.Codigo := Conexao.QryGetObject.FieldByName('CODIGO').AsString
    else
      ShowMessage('Registro não encontrado!');

  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEmpresa.getObject(Id: String): Boolean;
begin
  Try
    Result := False;
  
    if TUtil.Empty(Id) then
      Exit;

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' WHERE EMP_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Id;
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then begin
      Self.Codigo := Conexao.QryGetObject.FieldByName('EMP_CODIGO').AsString;
      Self.Razao := Conexao.QryGetObject.FieldByName('EMP_RAZAO').AsString;
      Self.Fantasia := Conexao.QryGetObject.FieldByName('EMP_FANTASIA').AsString;
      Self.DtCadastro := Conexao.QryGetObject.FieldByName('EMP_DT_CADASTRO').AsDateTime;
      Self.DtAbertura := Conexao.QryGetObject.FieldByName('EMP_DT_ABERTURA').AsDateTime;
      Self.Status := Conexao.QryGetObject.FieldByName('EMP_STATUS').AsInteger;
      Self.Alias := Conexao.QryGetObject.FieldByName('EMP_ALIAS').AsString;
      Self.Telefone := Conexao.QryGetObject.FieldByName('EMP_TELEFONE').AsString;
      Self.FoneFax := Conexao.QryGetObject.FieldByName('EMP_FONEFAX').AsString;
      Self.CNPJ := Conexao.QryGetObject.FieldByName('EMP_CNPJ').AsString;
      Self.IE := Conexao.QryGetObject.FieldByName('EMP_IE').AsString;
      Self.IEST := Conexao.QryGetObject.FieldByName('EMP_IEST').AsString;
      Self.IM := Conexao.QryGetObject.FieldByName('EMP_IM').AsString;
      Self.Crt := Conexao.QryGetObject.FieldByName('EMP_CRT').AsInteger;
      Self.Cnae := Conexao.QryGetObject.FieldByName('EMP_CNAE').AsString;
      Self.Email := Conexao.QryGetObject.FieldByName('EMP_EMAIL').AsString;
      Self.Pagina := Conexao.QryGetObject.FieldByName('EMP_PAGINA').AsString;
      Self.Observacao := Conexao.QryGetObject.FieldByName('EMP_MENSAGEM').AsString;
      Self.Contato := Conexao.QryGetObject.FieldByName('EMP_CONTATO').AsString;

      // getEndereco
      self.Endereco.getObject(Self.Codigo, 'EMPRESA');

      Result := True;
    end
    else
      ShowMessage('Registro não encontrado!');
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEmpresa.Insert: Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'INSERT INTO '+ TABLENAME +' (EMP_RAZAO, EMP_FANTASIA, EMP_DT_CADASTRO, EMP_DT_ABERTURA, EMP_STATUS, EMP_ALIAS, '+
                  ' EMP_TELEFONE, EMP_FONEFAX, EMP_CNPJ, EMP_IE, EMP_IEST, EMP_IM, EMP_CRT, EMP_CNAE, EMP_EMAIL, EMP_PAGINA, '+
                  ' EMP_MENSAGEM, EMP_CONTATO) '+
                  ' VALUES(:RAZAO, :FANTASIA, :CADASTRO, :ABERTURA, :STATUS, :ALIAS, :TELEFONE, :FONEFAX, :CNPJ, :IE, :IEST, :IM, '+
                  ' :CRT, :CNAE, :EMAIL, :PAGINA, :MENSAGEM, :CONTATO) ';

      ParamByName('RAZAO').AsString := Self.Razao;
      ParamByName('FANTASIA').AsString := Self.Fantasia;
      ParamByName('CADASTRO').AsDateTime := Self.DtCadastro;
      ParamByName('ABERTURA').AsDateTime := Self.DtAbertura;
      ParamByName('STATUS').AsInteger := Self.Status;
      ParamByName('ALIAS').AsString := Self.Alias;
      ParamByName('TELEFONE').AsString := Self.Telefone;
      ParamByName('FONEFAX').AsString := Self.FoneFax;
      ParamByName('CNPJ').AsString := Self.CNPJ;
      ParamByName('IE').AsString := Self.IE;
      ParamByName('IEST').AsString := Self.IEST;
      ParamByName('IM').AsString := Self.IM;
      ParamByName('CRT').AsInteger := Self.Crt;
      ParamByName('CNAE').AsString := Self.Cnae;
      ParamByName('EMAIL').AsString := Self.Email;
      ParamByName('PAGINA').AsString := Self.Pagina;
      ParamByName('MENSAGEM').AsString := Self.Observacao;
      ParamByName('CONTATO').AsString := Self.Contato;
      ExecSQL;
    end;

    // getCodigo para Insert Endereco
    getMaxId();

    if NOT Self.Endereco.Insert(Self.Codigo, 'EMPRESA') then begin
      ShowMessage('erro ao inserir endereco'); // mensagem temporaria, melhorar controle de transacao
      // deletar registro da empresa, pois houve erro ao inserir empresa
      Result := False;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEmpresa.Merge: Boolean;
begin
  if TUtil.Empty(Self.Codigo) then begin
    Result := Self.Insert();
  end
  else
    Result := Self.Update();
end;

procedure TEmpresa.setCodigo(const Value: String);
begin
  _codigo := Trim(Value);
end;

function TEmpresa.Update: Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'UPDATE '+ TABLENAME +' SET EMP_RAZAO =:RAZAO, EMP_FANTASIA =:FANTASIA, EMP_DT_CADASTRO =:CADASTRO, '+
                  'EMP_DT_ABERTURA =:ABERTURA, EMP_STATUS =:STATUS, EMP_ALIAS =:ALIAS, EMP_TELEFONE =:TELEFONE, '+
                  'EMP_FONEFAX =:FONEFAX, EMP_CNPJ =:CNPJ, EMP_IE =:IE, EMP_IEST =:IEST, EMP_IM =:IM, EMP_CRT =:CRT, '+
                  'EMP_CNAE =:CNAE, EMP_EMAIL =:EMAIL, EMP_PAGINA =:PAGINA, EMP_MENSAGEM =:MENSAGEM, EMP_CONTATO =:CONTATO '+
                  'WHERE EMP_CODIGO =:CODIGO';

      ParamByName('RAZAO').AsString := Self.Razao;
      ParamByName('FANTASIA').AsString := Self.Fantasia;
      ParamByName('CADASTRO').AsDateTime := Self.DtCadastro;
      ParamByName('ABERTURA').AsDateTime := Self.DtAbertura;
      ParamByName('STATUS').AsInteger := Self.Status;
      ParamByName('ALIAS').AsString := Self.Alias;
      ParamByName('TELEFONE').AsString := Self.Telefone;
      ParamByName('FONEFAX').AsString := Self.FoneFax;
      ParamByName('CNPJ').AsString := Self.CNPJ;
      ParamByName('IE').AsString := Self.IE;
      ParamByName('IEST').AsString := Self.IEST;
      ParamByName('IM').AsString := Self.IM;
      ParamByName('CRT').AsInteger := Self.Crt;
      ParamByName('CNAE').AsString := Self.Cnae;
      ParamByName('EMAIL').AsString := Self.Email;
      ParamByName('PAGINA').AsString := Self.Pagina;
      ParamByName('MENSAGEM').AsString := Self.Observacao;
      ParamByName('CONTATO').AsString := Self.Contato;
      ParamByName('CODIGO').AsString := Self.Codigo;
      ExecSQL;
    end;

    if NOT Self.Endereco.Update(Self.Endereco.Codigo) then begin
      ShowMessage('erro ao atualizar endereco'); // mensagem temporaria, melhorar controle de transacao
      // deletar registro da empresa, pois houve erro ao inserir empresa
      Result := False;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEmpresa.Validar: Boolean;
begin
  // Na validação de dados podemos colocar qualquer atributo para ser validado
  // codigo abaixo deve ser customizado por cada leitor!

  Result := True;
end;

function TEmpresa.getObjects: Boolean;
begin
  Try
    Result := False; 

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' ORDER BY EMP_RAZAO';
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

end.
