unit clEstoque;

interface

uses clProduto, clEmpresa;

type
  TEstoque = class(TObject)
  private
    // métodos privados
    function getCodigo: String;
    function getData: TDateTime;
    function getDocumento: String;
    function getFlag: Boolean;
    function getHora: TDateTime;
    function getQuantidade: Double;
    function getSaldo: Double;
    function getTipoMov: String;
    function getVlrCusto: Currency;
    procedure setCodigo(const Value: String);
    procedure setData(const Value: TDateTime);
    procedure setDocumento(const Value: String);
    procedure setFlag(const Value: Boolean);
    procedure setHora(const Value: TDateTime);
    procedure setQuantidade(const Value: Double);
    procedure setSaldo(const Value: Double);
    procedure setTipoMov(const Value: String);
    procedure setVlrCusto(const Value: Currency);
    function getProduto: TProduto;
    procedure setProduto(const Value: TProduto);
    function getEmpresa: TEmpresa;
    procedure setEmpresa(const Value: TEmpresa);


  protected
    // declaração de atributos
    _codigo: String;
    _data: TDateTime;
    _hora: TDateTime;
    _documento: String;
    _saldo: Double;
    _vlrCusto: Currency;
    _tipoMov: String;
    _quantidade: Double;
    _flag: Boolean;
    _produto: TProduto;
    _empresa: TEmpresa;

  public
    constructor create;

    // declaração das propriedades da classe, encapsulamento de atributos
    property Codigo: String read getCodigo write setCodigo;
    property Data: TDateTime read getData write setData;
    property Hora: TDateTime read getHora write setHora;
    property Documento: String read getDocumento write setDocumento;
    property Saldo: Double read getSaldo write setSaldo;
    property VlrCusto: Currency read getVlrCusto write setVlrCusto;
    property TipoMov: String read getTipoMov write setTipoMov;
    property Quantidade: Double read getQuantidade write setQuantidade;
    property Flag: Boolean read getFlag write setFlag;
    property Produto: TProduto read getProduto write setProduto;
    property Empresa: TEmpresa read getEmpresa write setEmpresa;

    function Validar(): Boolean;
    function Movimentacao(): Boolean;
    function ConsultarSaldo(): Double;
    function getObject(Id: String): Boolean;
    function getObjects: Boolean; overload;
    function getObjects(Id: String): Boolean; overload;

  end;

const
  TABLENAME = 'ESTOQUE';

implementation

uses SysUtils, dmConexao, Dialogs, clUtil, DB, ZAbstractRODataset;

{ TEstoque }

constructor TEstoque.create;
begin
  _produto := TProduto.Create;
  _empresa := TEmpresa.Create;
end;

function TEstoque.getCodigo: String;
begin
  Result := _codigo;
end;

function TEstoque.getData: TDateTime;
begin
  Result := _data;
end;

function TEstoque.getDocumento: String;
begin
  Result := _documento;
end;

function TEstoque.getFlag: Boolean;
begin
  Result := _flag;
end;

function TEstoque.getHora: TDateTime;
begin
  Result := _hora;
end;

function TEstoque.getProduto: TProduto;
begin
  Result := _produto;
end;

function TEstoque.getQuantidade: Double;
begin
  Result := _quantidade;
end;

function TEstoque.getSaldo: Double;
begin
  Result := _saldo;
end;

function TEstoque.ConsultarSaldo(): Double;
begin
  Try
    Result := 0;

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT SUM(EST_QUANTIDADE) - COALESCE((SELECT SUM(EST_QUANTIDADE) AS EST_SALDO FROM '+ TABLENAME +
                  ' WHERE PRO_CODIGO =:PRODUTO AND EMP_CODIGO =:EMPRESA AND EST_TIPO_MOV = '''+'S'+'''), 0) AS EST_SALDO '+
                  ' FROM '+ TABLENAME +
                  ' WHERE PRO_CODIGO =:PRODUTO AND EMP_CODIGO =:EMPRESA AND EST_TIPO_MOV = '''+'E'+''' ';

      ParamByName('PRODUTO').AsString := Self.Produto.Codigo;
      ParamByName('EMPRESA').AsString := Self.Empresa.Codigo;
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then
      Result := Conexao.QryGetObject.FieldByName('EST_SALDO').AsFloat;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEstoque.getTipoMov: String;
begin
  Result := _tipoMov;
end;

function TEstoque.getVlrCusto: Currency;
begin
  Result := _vlrCusto;
end;

function TEstoque.Movimentacao: Boolean;
begin
  // Movimentação de Estoque
  Try
    Result := False;

    with Conexao.QryCRUD do begin
      Close;
      SQL.Clear;
      SQL.Text := 'INSERT INTO '+ TABLENAME +' (PRO_CODIGO, EMP_CODIGO, EST_DATA, EST_HORA, EST_DOCUMENTO, EST_SALDO,  '+
                  ' EST_VLR_CUSTO, EST_TIPO_MOV, EST_QUANTIDADE) '+
                  ' VALUES (:PRODUTO, :EMPRESA, :DATA, :HORA, :DOCUMENTO, :SALDO, :VLR_CUSTO, :TIPO_MOV, :QUANTIDADE)';

      ParamByName('PRODUTO').AsString := Self.Produto.Codigo;
      ParamByName('EMPRESA').AsString := Self.Empresa.Codigo;
      ParamByName('DATA').AsDateTime := Self.Data;
      ParamByName('HORA').AsDateTime := Now; // hora atual
      ParamByName('DOCUMENTO').AsString := Self.Documento;

      // verificando o tipo de movimento
      if Self.TipoMov = 'E' then
        ParamByName('SALDO').AsFloat := (Self.ConsultarSaldo + Self.Quantidade)
      else
        ParamByName('SALDO').AsFloat := (Self.ConsultarSaldo - Self.Quantidade);

      ParamByName('VLR_CUSTO').AsCurrency := Self.VlrCusto;
      ParamByName('TIPO_MOV').AsString := Self.TipoMov;
      ParamByName('QUANTIDADE').AsFloat := Self.Quantidade;
      ExecSQL;
    end;

    Result := True;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEstoque.getObjects: Boolean;
begin
  Try
    Result := False;

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' ORDER BY EST_CODIGO';
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

// pegar movimentação de estoque pelo ID (PRODUTO)
function TEstoque.getObject(Id: String): Boolean;
begin
  try
    Result := False;

    if TUtil.Empty(Id) then
      Exit;

    with Conexao.QryGetObject do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' WHERE PRO_CODIGO =:CODIGO AND EMP_CODIGO =:EMPRESA';
      ParamByName('CODIGO').AsString := Id;
      ParamByName('EMPRESA').AsString := Self.Empresa.Codigo;
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then begin
      Self.Codigo := Conexao.QryGetObject.FieldByName('EST_CODIGO').AsString;
      Self.Produto.Codigo := Conexao.QryGetObject.FieldByName('PRO_CODIGO').AsString;
      Self.Data := Conexao.QryGetObject.FieldByName('EST_DATA').AsDateTime;
      Self.Hora := Conexao.QryGetObject.FieldByName('EST_HORA').AsDateTime;
      Self.Documento := Conexao.QryGetObject.FieldByName('EST_DOCUMENTO').AsString;
      Self.Saldo := Conexao.QryGetObject.FieldByName('EST_SALDO').AsFloat;
      Self.VlrCusto := Conexao.QryGetObject.FieldByName('EST_VLR_CUSTO').AsCurrency;
      Self.TipoMov := Conexao.QryGetObject.FieldByName('EST_TIPO_MOV').AsString;
      Self.Quantidade := Conexao.QryGetObject.FieldByName('EST_QUANTIDADE').AsFloat;
      Self.Flag := Conexao.QryGetObject.FieldByName('EST_FLAG').AsBoolean;
      Result := True;
    end;
   // else
   //   ShowMessage('Registro não encontrado!');
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

procedure TEstoque.setCodigo(const Value: String);
begin
  _codigo := Trim(Value);
end;

procedure TEstoque.setData(const Value: TDateTime);
begin
  _data := Value;
end;

procedure TEstoque.setDocumento(const Value: String);
begin
  _documento := Trim(Value);
end;

procedure TEstoque.setFlag(const Value: Boolean);
begin
  _flag := Value;
end;

procedure TEstoque.setHora(const Value: TDateTime);
begin
  _hora := Value;
end;

procedure TEstoque.setProduto(const Value: TProduto);
begin
  _produto := Value;
end;

procedure TEstoque.setQuantidade(const Value: Double);
begin
  if Value > 0 then
    _quantidade := Value
  else
    _quantidade := 0;
end;

procedure TEstoque.setSaldo(const Value: Double);
begin
  _saldo := Value;
end;

procedure TEstoque.setTipoMov(const Value: String);
begin
  _tipoMov := Trim(Value);
end;

procedure TEstoque.setVlrCusto(const Value: Currency);
begin
  if Value > 0 then
    _vlrCusto := Value
  else
    _vlrCusto := 0;
end;

function TEstoque.Validar: Boolean;
begin
  // validação de atributos
  if Length(DateToStr(_data)) <> 10 then begin
    ShowMessage('Data Inválida!');
    Result := false;
    Exit;
  end
  else if _quantidade = 0 then begin
    ShowMessage('Quantidade Inválida!');
    Result := False;
    Exit;
  end;
  
  Result := True;
end;

function TEstoque.getObjects(Id: String): Boolean;
begin
  Try
    Result := False;

    with Conexao.QryEstoque do begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT * FROM '+ TABLENAME +' WHERE PRO_CODIGO =:CODIGO AND EMP_CODIGO =:EMPRESA ORDER BY EST_CODIGO';
      ParamByName('CODIGO').AsString := Id;
      ParamByName('EMPRESA').AsString := Self.Empresa.Codigo;
      Open;
      First;
    end;

    if Conexao.QryGetObject.RecordCount > 0 then begin
      Self.getObject(Id);
      Result := True;
    end;
  Except
    on E : Exception do
      ShowMessage('Classe: '+ e.ClassName + chr(13) + 'Mensagem: '+ e.Message);
  end;
end;

function TEstoque.getEmpresa: TEmpresa;
begin
  Result := _empresa;
end;

procedure TEstoque.setEmpresa(const Value: TEmpresa);
begin
  _empresa := Value;
end;

end.
