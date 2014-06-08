unit clPessoaJ;

interface

uses clPessoa;

type
  TPessoaJ = class(TPessoa)  // classe herda de TPessoa
  private
    function getAlias: String;
    function getCnae: String;
    function getCnpj: String;
    function getContato: String;
    function getCrt: Integer;
    function getDtAbertura: TDateTime;
    function getFantasia: String;
    function getIE: String;
    function getIEST: String;
    function getIM: String;
    function getRazao: String;
    procedure setAlias(const Value: String);
    procedure setCnae(const Value: String);
    procedure setCnpj(const Value: String);
    procedure setContato(const Value: String);
    procedure setCrt(const Value: Integer);
    procedure setDtAbertura(const Value: TDateTime);
    procedure setFantasia(const Value: String);
    procedure setIE(const Value: String);
    procedure setIEST(const Value: String);
    procedure setIM(const Value: String);
    procedure setRazao(const Value: String);

  protected
    // declaração de atributos
    _razao: String;
    _fantasia: String;
    _cnpj: String;
    _ie: String;
    _iest: String;
    _im: String;
    _cnae: String;
    _crt: Integer;
    _alias: String;
    _dtAbertura: TDateTime;
    _contato: String;

  public
    // declaração das propriedades da classe, encapsulamento de atributos
    property Razao: String read getRazao write setRazao;
    property Fantasia: String read getFantasia write setFantasia;
    property Cnpj: String read getCnpj write setCnpj;
    property IE: String read getIE write setIE;
    property IEST: String read getIEST write setIEST;
    property IM: String read getIM write setIM;
    property Cnae: String read getCnae write setCnae;
    property Crt: Integer read getCrt write setCrt;
    property Alias: String read getAlias write setAlias;
    property DtAbertura: TDateTime read getDtAbertura write setDtAbertura;
    property Contato: String read getContato write setContato;
    // na linha acima antes do ponto e virgula (setContato) pressione Ctrl + Shift + C
    // para gerar os métodos acessores getter e setter automaticamente

  end;

implementation

uses SysUtils;

{ TPessoaJ }

function TPessoaJ.getAlias: String;
begin
  Result := _alias;
end;

function TPessoaJ.getCnae: String;
begin
  Result := _cnae;
end;

function TPessoaJ.getCnpj: String;
begin
  Result := _cnpj;
end;

function TPessoaJ.getContato: String;
begin
  Result := _contato;
end;

function TPessoaJ.getCrt: Integer;
begin
  Result := _crt;
end;

function TPessoaJ.getDtAbertura: TDateTime;
begin
  Result := _dtAbertura;
end;

function TPessoaJ.getFantasia: String;
begin
  Result := _fantasia;
end;

function TPessoaJ.getIE: String;
begin
  Result := _ie;
end;

function TPessoaJ.getIEST: String;
begin
  Result := _iest;
end;

function TPessoaJ.getIM: String;
begin
  Result := _im;
end;

function TPessoaJ.getRazao: String;
begin
  Result := _razao;
end;

procedure TPessoaJ.setAlias(const Value: String);
begin
  _alias := Trim(Value);
end;

procedure TPessoaJ.setCnae(const Value: String);
begin
  _cnae := Trim(Value);
end;

procedure TPessoaJ.setCnpj(const Value: String);
begin
  _cnpj := Trim(Value);
end;

procedure TPessoaJ.setContato(const Value: String);
begin
  _contato := Trim(Value);
end;

procedure TPessoaJ.setCrt(const Value: Integer);
begin
  _crt := Value;
end;

procedure TPessoaJ.setDtAbertura(const Value: TDateTime);
begin
  _dtAbertura := Value;
end;

procedure TPessoaJ.setFantasia(const Value: String);
begin
  _fantasia := Trim(Value);
end;

procedure TPessoaJ.setIE(const Value: String);
begin
  _ie := Trim(Value);
end;

procedure TPessoaJ.setIEST(const Value: String);
begin
  _iest := Trim(Value);
end;

procedure TPessoaJ.setIM(const Value: String);
begin
  _im := Trim(Value);
end;

procedure TPessoaJ.setRazao(const Value: String);
begin
  _razao := Trim(Value);
end;

end.
