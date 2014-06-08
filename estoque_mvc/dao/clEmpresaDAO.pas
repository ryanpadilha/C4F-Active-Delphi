unit clEmpresaDAO;

interface

uses clEmpresa;

type
  TEmpresaDAO = class(TObject)
  private
    // métodos privados
    function Insert(Empresa: TEmpresa): Boolean;
    function Update(Empresa: TEmpresa): Boolean;

  protected

  public
    // métodos publicos
    function Merge(Empresa: TEmpresa): Boolean;
    function Delete(Empresa: TEmpresa): Boolean;
    function getObject(Id: String): TEmpresa; //function getObject(Id: String): Boolean;
    function getMaxId: String; //procedure getMaxId;
    function getObjects: Boolean;
    function getField(Empresa: TEmpresa; campo, coluna: String): String;
  end;

const
  TABLENAME = 'EMPRESA';

implementation

uses dmConexao, Dialogs, SysUtils, clUtil;

{ TEmpresaDAO }

function TEmpresaDAO.Delete(Empresa: TEmpresa): Boolean;
begin
  Try
    Result := False;

    // deletar registros filhos
    if NOT Empresa.Endereco.Delete(Empresa.Endereco.Codigo) then begin
      ShowMessage('erro ao deletar endereco'); // mensagem temporaria, melhor controle de transacao
      // deletar registro da empresa, pois houve erro ao inserir empresa
      Result := False;
    end;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'DELETE FROM '+ TABLENAME +' WHERE EMP_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Empresa.Codigo;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEmpresaDAO.getField(Empresa: TEmpresa; campo, coluna: String): String;
begin
  Try
    Result := '';

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT '+ campo +' FROM '+ TABLENAME;

      if coluna = 'RAZAO' then begin
        SQL.Add(' WHERE EMP_RAZAO =:RAZAO ');
        ParamByName('RAZAO').AsString := Empresa.Razao;
      end
      else if coluna = 'FANTASIA' then begin
        SQL.Add(' WHERE EMP_FANTASIA =:FANTASIA ');
        ParamByName('FANTASIA').AsString := Empresa.Fantasia;
      end
      else if coluna = 'CODIGO' then begin
        SQL.Add(' WHERE EMP_CODIGO =:CODIGO ');
        ParamByName('CODIGO').AsString := Empresa.Codigo;
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

function TEmpresaDAO.getMaxId: String;
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
      Result := Conexao.QryGetObject.FieldByName('CODIGO').AsString //Self.Codigo := Conexao.QryGetObject.FieldByName('CODIGO').AsString
    else
      ShowMessage('Registro não encontrado!');

  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEmpresaDAO.getObject(Id: String): TEmpresa;
var
  Empresa: TEmpresa;
begin
  Try
    Result := nil;

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

    // instanciar o objeto retornado
    Empresa := TEmpresa.Create;

    if Conexao.QryGetObject.RecordCount > 0 then begin
      Empresa.Codigo := Conexao.QryGetObject.FieldByName('EMP_CODIGO').AsString;
      Empresa.Razao := Conexao.QryGetObject.FieldByName('EMP_RAZAO').AsString;
      Empresa.Fantasia := Conexao.QryGetObject.FieldByName('EMP_FANTASIA').AsString;
      Empresa.DtCadastro := Conexao.QryGetObject.FieldByName('EMP_DT_CADASTRO').AsDateTime;
      Empresa.DtAbertura := Conexao.QryGetObject.FieldByName('EMP_DT_ABERTURA').AsDateTime;
      Empresa.Status := Conexao.QryGetObject.FieldByName('EMP_STATUS').AsInteger;
      Empresa.Alias := Conexao.QryGetObject.FieldByName('EMP_ALIAS').AsString;
      Empresa.Telefone := Conexao.QryGetObject.FieldByName('EMP_TELEFONE').AsString;
      Empresa.FoneFax := Conexao.QryGetObject.FieldByName('EMP_FONEFAX').AsString;
      Empresa.CNPJ := Conexao.QryGetObject.FieldByName('EMP_CNPJ').AsString;
      Empresa.IE := Conexao.QryGetObject.FieldByName('EMP_IE').AsString;
      Empresa.IEST := Conexao.QryGetObject.FieldByName('EMP_IEST').AsString;
      Empresa.IM := Conexao.QryGetObject.FieldByName('EMP_IM').AsString;
      Empresa.Crt := Conexao.QryGetObject.FieldByName('EMP_CRT').AsInteger;
      Empresa.Cnae := Conexao.QryGetObject.FieldByName('EMP_CNAE').AsString;
      Empresa.Email := Conexao.QryGetObject.FieldByName('EMP_EMAIL').AsString;
      Empresa.Pagina := Conexao.QryGetObject.FieldByName('EMP_PAGINA').AsString;
      Empresa.Observacao := Conexao.QryGetObject.FieldByName('EMP_MENSAGEM').AsString;
      Empresa.Contato := Conexao.QryGetObject.FieldByName('EMP_CONTATO').AsString;

      // getEndereco
      Empresa.Endereco.getObject(Empresa.Codigo, 'EMPRESA');

      Result := Empresa;
    end
    else
      ShowMessage('Registro não encontrado!');
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEmpresaDAO.getObjects: Boolean;
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

function TEmpresaDAO.Insert(Empresa: TEmpresa): Boolean;
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

      ParamByName('RAZAO').AsString := Empresa.Razao;
      ParamByName('FANTASIA').AsString := Empresa.Fantasia;
      ParamByName('CADASTRO').AsDateTime := Empresa.DtCadastro;
      ParamByName('ABERTURA').AsDateTime := Empresa.DtAbertura;
      ParamByName('STATUS').AsInteger := Empresa.Status;
      ParamByName('ALIAS').AsString := Empresa.Alias;
      ParamByName('TELEFONE').AsString := Empresa.Telefone;
      ParamByName('FONEFAX').AsString := Empresa.FoneFax;
      ParamByName('CNPJ').AsString := Empresa.CNPJ;
      ParamByName('IE').AsString := Empresa.IE;
      ParamByName('IEST').AsString := Empresa.IEST;
      ParamByName('IM').AsString := Empresa.IM;
      ParamByName('CRT').AsInteger := Empresa.Crt;
      ParamByName('CNAE').AsString := Empresa.Cnae;
      ParamByName('EMAIL').AsString := Empresa.Email;
      ParamByName('PAGINA').AsString := Empresa.Pagina;
      ParamByName('MENSAGEM').AsString := Empresa.Observacao;
      ParamByName('CONTATO').AsString := Empresa.Contato;
      ExecSQL;
    end;

    // getCodigo para Insert Endereco
    Empresa.Codigo := getMaxId();

    if NOT Empresa.Endereco.Insert(Empresa.Codigo, 'EMPRESA') then begin
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

function TEmpresaDAO.Merge(Empresa: TEmpresa): Boolean;
begin
  if TUtil.Empty(Empresa.Codigo) then begin
    Result := Self.Insert(Empresa);
  end
  else
    Result := Self.Update(Empresa);
end;

function TEmpresaDAO.Update(Empresa: TEmpresa): Boolean;
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

      ParamByName('RAZAO').AsString := Empresa.Razao;
      ParamByName('FANTASIA').AsString := Empresa.Fantasia;
      ParamByName('CADASTRO').AsDateTime := Empresa.DtCadastro;
      ParamByName('ABERTURA').AsDateTime := Empresa.DtAbertura;
      ParamByName('STATUS').AsInteger := Empresa.Status;
      ParamByName('ALIAS').AsString := Empresa.Alias;
      ParamByName('TELEFONE').AsString := Empresa.Telefone;
      ParamByName('FONEFAX').AsString := Empresa.FoneFax;
      ParamByName('CNPJ').AsString := Empresa.CNPJ;
      ParamByName('IE').AsString := Empresa.IE;
      ParamByName('IEST').AsString := Empresa.IEST;
      ParamByName('IM').AsString := Empresa.IM;
      ParamByName('CRT').AsInteger := Empresa.Crt;
      ParamByName('CNAE').AsString := Empresa.Cnae;
      ParamByName('EMAIL').AsString := Empresa.Email;
      ParamByName('PAGINA').AsString := Empresa.Pagina;
      ParamByName('MENSAGEM').AsString := Empresa.Observacao;
      ParamByName('CONTATO').AsString := Empresa.Contato;
      ParamByName('CODIGO').AsString := Empresa.Codigo;
      ExecSQL;
    end;

    if NOT Empresa.Endereco.Update(Empresa.Endereco.Codigo) then begin
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

end.
