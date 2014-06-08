unit clProduto;

interface

uses clUnidade, clMarca;

type
  TProduto = class(TObject)
  private
    // métodos privados
    function getCodigo: String;
    function getDescReduzido: String;
    function getDescricao: String;
    function getStatus: Boolean;
    procedure setCodigo(const Value: String);
    procedure setDescReduzido(const Value: String);
    procedure setDescricao(const Value: String);
    procedure setStatus(const Value: Boolean);

    function Insert(): Boolean;
    function Update(): Boolean;
    function getMarca: TMarca;
    function getUnidade: TUnidade;
    procedure setMarca(const Value: TMarca);
    procedure setUnidade(const Value: TUnidade);
    function getCodigoPrinc: String;
    procedure setCodigoPrinc(const Value: String);

    
  protected
    // declaração de atributos
    _codigo: String;
    _codigoPrincipal: String;
    _descricao: String;
    _descReduzido: String;
    _status: Boolean;
    _unidade: TUnidade; //
    _marca: TMarca; //
    // categoria...

  public
    // método construtor definido por nós
    constructor Create;

    // declaração das propriedades da classe, encapsulamento de atributos
    property Codigo: String read getCodigo write setCodigo;
    property CodigoPrincipal: String read getCodigoPrinc write setCodigoPrinc;
    property Descricao: String read getDescricao write setDescricao;
    property DescReduzido: String read getDescReduzido write setDescReduzido;
    property Status: Boolean read getStatus write setStatus;
    property Unidade: TUnidade read getUnidade write setUnidade;
    property Marca: TMarca read getMarca write setMarca;
    // na linha acima antes do ponto e virgula (setStatus) pressione Ctrl + Shift + C
    // para gerar os métodos acessores getter e setter automaticamente

    // métodos públicos
    function Validar(): Boolean;
    function Merge(): Boolean;
    function Delete(): Boolean;
    function getObject(Id: String): Boolean;
    function getObjects(): Boolean;
    function getField(campo: String; coluna: String): String;
    
  end;

const
  TABLENAME = 'PRODUTO';

implementation

uses clUtil, dmConexao, SysUtils, Dialogs;

{ TProduto }

constructor TProduto.Create;
begin
  _unidade := TUnidade.Create; //
  _marca := TMarca.Create; // 
end;

function TProduto.Delete: Boolean;
begin
  try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'DELETE FROM '+ TABLENAME +' WHERE PRO_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Self.Codigo;
      ExecSQL;
    end;
  
    Result := true;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TProduto.getCodigo: String;
begin
  Result := _codigo;
end;

function TProduto.getCodigoPrinc: String;
begin
  Result := _codigoPrincipal;
end;

function TProduto.getDescReduzido: String;
begin
  Result := _descReduzido;
end;

function TProduto.getDescricao: String;
begin
  Result := _descricao;
end;

function TProduto.getField(campo, coluna: String): String;
begin
  Try
    Result := '';

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT '+ campo +' FROM '+ TABLENAME;

      if coluna = 'DESCRICAO' then begin
        SQL.Add(' WHERE PRO_DESCRICAO =:DESCRICAO ');
        ParamByName('DESCRICAO').AsString := Self.Descricao;
      end
      else if coluna = 'CODIGO' then begin
        SQL.Add(' WHERE PRO_CODIGO =:CODIGO ');
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

function TProduto.getMarca: TMarca;
begin
  Result := _marca;
end;

function TProduto.getObject(Id: String): Boolean;
begin
  try
    Result := False;

    if TUtil.Empty(Id) then
      Exit;

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' WHERE PRO_CODIGO =:CODIGO';
      ParamByName('CODIGO').AsString := Id;
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then begin
      Self.Codigo := Conexao.QryGetObject.FieldByName('PRO_CODIGO').AsString;
      Self.CodigoPrincipal := Conexao.QryGetObject.FieldByName('PRO_C_PRINCIPAL').AsString;
      Self.Descricao := Conexao.QryGetObject.FieldByName('PRO_DESCRICAO').AsString;
      Self.DescReduzido := Conexao.QryGetObject.FieldByName('PRO_DESC_REDUZIDO').AsString;
      Self.Unidade.Codigo := Conexao.QryGetObject.FieldByName('UND_CODIGO').AsString;
      Self.Marca.Codigo := Conexao.QryGetObject.FieldByName('MAR_CODIGO').AsString;
      Self.Status := Conexao.QryGetObject.FieldByName('PRO_STATUS').AsBoolean;

      Result := True;
    end
    else
      ShowMessage('Registro não encontrado!');
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TProduto.getObjects: Boolean;
begin
  Try
    Result := False; 

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' ORDER BY PRO_DESCRICAO';
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

function TProduto.getStatus: Boolean;
begin
  Result := _status;
end;

function TProduto.getUnidade: TUnidade;
begin
  Result := _unidade;
end;

function TProduto.Insert: Boolean;
begin
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'INSERT INTO '+ TABLENAME +' (PRO_C_PRINCIPAL, PRO_STATUS, PRO_DESCRICAO, PRO_DESC_REDUZIDO, MAR_CODIGO, UND_CODIGO) '+
                  ' VALUES(:C_PRINCIPAL, :STATUS, :DESCRICAO, :DESC_REDUZIDA, :MARCA, :UNIDADE) ';

      ParamByName('C_PRINCIPAL').AsString := Self.CodigoPrincipal;
      ParamByName('STATUS').AsBoolean := Self.Status;
      ParamByName('DESCRICAO').AsString := Self.Descricao;
      ParamByName('DESC_REDUZIDA').AsString := Self.DescReduzido;
      ParamByName('MARCA').AsString := Self.Marca.Codigo;
      ParamByName('UNIDADE').AsString := Self.Unidade.Codigo;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TProduto.Merge: Boolean;
begin
  if TUtil.Empty(Self.Codigo) then
    Result := Self.Insert()
  else
    Result := Self.Update();
end;

procedure TProduto.setCodigo(const Value: String);
begin
  _codigo := Trim(Value);
end;

procedure TProduto.setCodigoPrinc(const Value: String);
begin
  _codigoPrincipal := Trim(Value);
end;

procedure TProduto.setDescReduzido(const Value: String);
begin
  _descReduzido := Trim(Value);
end;

procedure TProduto.setDescricao(const Value: String);
begin
  _descricao := Trim(Value);
end;

procedure TProduto.setMarca(const Value: TMarca);
begin
  _marca := Value;
end;

procedure TProduto.setStatus(const Value: Boolean);
begin
  _status := Value;
end;

procedure TProduto.setUnidade(const Value: TUnidade);
begin
  _unidade := Value;
end;

function TProduto.Update: Boolean;
begin

  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'UPDATE '+ TABLENAME +' SET PRO_C_PRINCIPAL =:C_PRINCIPAL, PRO_STATUS =:STATUS, PRO_DESCRICAO =:DESCRICAO, '+
                  ' PRO_DESC_REDUZIDO =:DESC_REDUZIDA, MAR_CODIGO =:MARCA, UND_CODIGO =:UNIDADE '+
                  ' WHERE PRO_CODIGO =:CODIGO ';
                  
      ParamByName('C_PRINCIPAL').AsString := Self.CodigoPrincipal;
      ParamByName('STATUS').AsBoolean := Self.Status;
      ParamByName('DESCRICAO').AsString := Self.Descricao;
      ParamByName('DESC_REDUZIDA').AsString := Self.DescReduzido;
      ParamByName('MARCA').AsString := Self.Marca.Codigo;
      ParamByName('UNIDADE').AsString := Self.Unidade.Codigo;
      ParamByName('CODIGO').AsString := Self.Codigo;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TProduto.Validar: Boolean;
begin

  Result := True;
end;

end.
