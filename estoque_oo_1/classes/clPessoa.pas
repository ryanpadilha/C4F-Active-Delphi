unit clPessoa;

interface

uses clEndereco;

type
  TPessoa = class(TObject)
  private
    function getCelular: String;
    function getDtAlteracao: TDateTime;
    function getDtCadastro: TDateTime;
    function getEmail: String;
    function getEndereco: TEndereco;
    function getFoneFax: String;
    function getObservacao: String;
    function getPagina: String;
    function getStatus: Integer;
    function getTelefone: String;
    procedure setCelular(const Value: String);
    procedure setDtAlteracao(const Value: TDateTime);
    procedure setDtCadastro(const Value: TDateTime);
    procedure setEmail(const Value: String);
    procedure setEndereco(const Value: TEndereco);
    procedure setFoneFax(const Value: String);
    procedure setObservacao(const Value: String);
    procedure setPagina(const Value: String);
    procedure setStatus(const Value: Integer);
    procedure setTelefone(const Value: String);

  protected
    // declaração de atributos
    _telefone: String;
    _fonefax: String;
    _celular: String;
    _email: String;
    _pagina: String;
    _observacao: String;
    _status: Integer;
    _endereco: TEndereco;
    _dtCadastro: TDateTime;
    _dtAlteracao: TDateTime;

  public
    // declaração das propriedades da classe, encapsulamento de atributos
    property Telefone: String read getTelefone write setTelefone;
    property FoneFax: String read getFoneFax write setFoneFax;
    property Celular: String read getCelular write setCelular;
    property Email: String read getEmail write setEmail;
    property Pagina: String read getPagina write setPagina;
    property Observacao: String read getObservacao write setObservacao;
    property Status: Integer read getStatus write setStatus;
    property Endereco: TEndereco read getEndereco write setEndereco;
    property DtCadastro: TDateTime read getDtCadastro write setDtCadastro;
    property DtAlteracao: TDateTime read getDtAlteracao write setDtAlteracao;
    // na linha acima antes do ponto e virgula (setDtAlteracao) pressione Ctrl + Shift + C
    // para gerar os métodos acessores getter e setter automaticamente

  end;

implementation

uses SysUtils;

{ TPessoa }

function TPessoa.getCelular: String;
begin
  Result := _celular;
end;

function TPessoa.getDtAlteracao: TDateTime;
begin
  Result := _dtAlteracao;
end;

function TPessoa.getDtCadastro: TDateTime;
begin
  Result := _dtCadastro;
end;

function TPessoa.getEmail: String;
begin
  Result := _email;
end;

function TPessoa.getEndereco: TEndereco;
begin
  Result := _endereco;
end;

function TPessoa.getFoneFax: String;
begin
  Result := _fonefax;
end;

function TPessoa.getObservacao: String;
begin
  Result := _observacao;
end;

function TPessoa.getPagina: String;
begin
  Result := _pagina;
end;

function TPessoa.getStatus: Integer;
begin
  Result := _status;
end;

function TPessoa.getTelefone: String;
begin
  Result := _telefone;
end;

procedure TPessoa.setCelular(const Value: String);
begin
  _celular := Trim(Value);
end;

procedure TPessoa.setDtAlteracao(const Value: TDateTime);
begin
  _dtAlteracao := Value;
end;

procedure TPessoa.setDtCadastro(const Value: TDateTime);
begin
  _dtCadastro := Value;
end;

procedure TPessoa.setEmail(const Value: String);
begin
  _email := Trim(Value);
end;

procedure TPessoa.setEndereco(const Value: TEndereco);
begin
  _endereco := Value;
end;

procedure TPessoa.setFoneFax(const Value: String);
begin
  _fonefax := Trim(Value);
end;

procedure TPessoa.setObservacao(const Value: String);
begin
  _observacao := Trim(Value);
end;

procedure TPessoa.setPagina(const Value: String);
begin
  _pagina := Trim(Value);
end;

procedure TPessoa.setStatus(const Value: Integer);
begin
  // 0- inativo, 1- ativo
  _status := Value;
end;

procedure TPessoa.setTelefone(const Value: String);
begin
  _telefone := Trim(Value);
end;

end.
