unit clEmpresa;

interface

uses clPessoaJ, clEndereco;

type
  TEmpresa = class(TPessoaJ)
  private
    // métodos privados
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

  end;

implementation

uses SysUtils, clPessoa, clUtil, Math, Dialogs;

{ TEmpresa }

constructor TEmpresa.Create;
begin
  _endereco := TEndereco.Create;
end;

function TEmpresa.getCodigo: String;
begin
  Result := _codigo;
end;

procedure TEmpresa.setCodigo(const Value: String);
begin
  _codigo := Trim(Value);
end;

function TEmpresa.Validar: Boolean;
begin
  // Na validação de dados podemos colocar qualquer atributo para ser validado
  // codigo abaixo deve ser customizado por cada leitor!

  Result := True;
end;

end.
