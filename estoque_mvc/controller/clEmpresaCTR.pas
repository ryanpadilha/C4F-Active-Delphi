unit clEmpresaCTR;

interface

uses untCadastroEmpresa, clEmpresa, IController, clEmpresaDAO;

type
  TEmpresaCTR = class(TObject, Controller)
  private

    FrmCadastro: TFrmCadastroEmpresa; // camada de visualizacao
    Empresa: TEmpresa;  // objeto regra de negocio
    EmpresaDAO: TEmpresaDAO; // objeto de persistencia

    // métodos privados
    procedure SalvarClick(Sender: TObject);
    procedure CancelarClick(Sender: TObject);
    procedure ExcluirClick(Sender: TObject);
    procedure PesquisarClick(Sender: TObject);
    procedure SetupObject;
    procedure Inicializar;

    // internos Interface
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    
  protected

  public
    // métodos publicos
    constructor Create;

  end;

implementation

uses clUtil, SysUtils, Dialogs, Windows, Forms;

{ TEmpresaCTR }

procedure TEmpresaCTR.CancelarClick(Sender: TObject);
begin
  TUtil.LimparFields(Self.FrmCadastro);
  Empresa := nil;
  Empresa := TEmpresa.Create;
  Self.FrmCadastro.edtFantasia.SetFocus;
end;

constructor TEmpresaCTR.Create;
begin
  Inicializar;
end;

procedure TEmpresaCTR.ExcluirClick(Sender: TObject);
begin
  if TUtil.Empty(Empresa.Codigo) then
    Exit;

  if MessageBox(Application.Handle, 'Deseja Realmente Excluir o Registro?', 'Controle Estoque', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = ID_NO then
    Exit;

  if TUtil.NotEmpty(Empresa.Codigo) then begin
    if NOT EmpresaDAO.Delete(Sender as TEmpresa) then
      ShowMessage('Erro ao Excluir o Registro.')
    else
      Self.CancelarClick(Self); //sppCancelarClick(Self);
  end;
end;

procedure TEmpresaCTR.Inicializar;
begin
  // Instanciação do objeto Empresa e EmpresaDAO na memória HEAP!
  Empresa := TEmpresa.Create;
  EmpresaDAO := TEmpresaDAO.Create;

  // Camada de Visualização - Formulário
  if NOT Assigned(FrmCadastro) then
    FrmCadastro := TFrmCadastroEmpresa.Create(Application);

  FrmCadastro.sppSalvar.OnClick := SalvarClick;
  FrmCadastro.sppCancelar.OnClick := CancelarClick;
  FrmCadastro.sppExcluir.OnClick := ExcluirClick;
  FrmCadastro.sppCancelar.OnClick := CancelarClick;
  FrmCadastro.ShowModal; // exibir na tela
end;

procedure TEmpresaCTR.PesquisarClick(Sender: TObject);
begin
{
  O evento de pesquisa NÃO foi implementado, pois ainda não foi citado no artigo como realizamos a pesquisa.
  No artigo (parte II) não foi citado nenhum formulário de pesquisa, e o mesmo deve ser criado para efetuar a pesquisa.

  O leitor tem a liberdade de implementar a pesquisa conforme sua necessidade.
  Qualquer dúvida entrar em contato com o colunista.
}
end;

function TEmpresaCTR.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  // não implementado, apenas declarado
end;

procedure TEmpresaCTR.SalvarClick(Sender: TObject);
var
  Operacao: String;
begin
  Operacao := 'U';
  Empresa.Codigo := Self.FrmCadastro.edtCodigo.Text;
  Empresa.Razao := Self.FrmCadastro.edtRazao.Text;
  Empresa.Fantasia := Self.FrmCadastro.edtFantasia.Text;
  Empresa.DtAbertura := StrToDate(Self.FrmCadastro.mskAbertura.Text);
  Empresa.DtCadastro := StrToDate(Self.FrmCadastro.mskCadastro.Text);
  Empresa.Status := Self.FrmCadastro.cmbStatus.ItemIndex;
  Empresa.Alias := Self.FrmCadastro.edtAlias.Text;

  // telefones
  Empresa.Telefone := Self.FrmCadastro.mskTelefone.Text;
  Empresa.FoneFax := Self.FrmCadastro.mskFoneFax.Text;

  // documentos
  Empresa.CNPJ := Self.FrmCadastro.mskCNPJ.Text;
  Empresa.IE := Self.FrmCadastro.edtIE.Text;
  Empresa.IM := Self.FrmCadastro.edtIM.Text;
  Empresa.IEST := Self.FrmCadastro.edtIEST.Text;

  Empresa.Email := Self.FrmCadastro.edtEmail.Text;
  Empresa.Pagina := Self.FrmCadastro.edtPagina.Text;
  Empresa.Crt := Self.FrmCadastro.cmbCRT.ItemIndex;
  Empresa.Cnae := Self.FrmCadastro.edtCNAE.Text;
  Empresa.Contato := Self.FrmCadastro.edtContato.Text;
  Empresa.Observacao := Self.FrmCadastro.memoObservacao.Text;
  Empresa.Contato := Self.FrmCadastro.edtContato.Text;

  // endereco
  Empresa.Endereco.Correspondencia := Self.FrmCadastro.chkEnderecoCorresp.Checked;
  Empresa.Endereco.Logradouro := Self.FrmCadastro.edtLogradouro.Text;
  Empresa.Endereco.Numero := Self.FrmCadastro.edtNumero.Text;
  Empresa.Endereco.Complemento := Self.FrmCadastro.edtComplemento.Text;
  Empresa.Endereco.Bairro := Self.FrmCadastro.edtBairro.Text;
  Empresa.Endereco.Cidade := Self.FrmCadastro.edtCidade.Text;
  Empresa.Endereco.Cep := Self.FrmCadastro.mskCEP.Text;
  Empresa.Endereco.Referencia := Self.FrmCadastro.edtPontoReferencia.Text;
  Empresa.Endereco.Tipo := Self.FrmCadastro.cmbTipoEndereco.ItemIndex;

  if TUtil.Empty(Empresa.Codigo) then
    Operacao := 'I';

  if Empresa.Validar() then
    if EmpresaDAO.Merge(Empresa) then begin
      TUtil.LimparFields(Self.FrmCadastro);

      if Operacao = 'I' then
        ShowMessage('Registro Gravado com Sucesso!')
      else
        ShowMessage('Registro Atualizado com Sucesso!');

      Self.FrmCadastro.edtFantasia.SetFocus;
    end;
end;

procedure TEmpresaCTR.SetupObject;
begin
  Self.FrmCadastro.edtCodigo.Text := Empresa.Codigo;
  Self.FrmCadastro.edtFantasia.Text := Empresa.Fantasia;
  Self.FrmCadastro.edtRazao.Text := Empresa.Razao;
  Self.FrmCadastro.mskCadastro.Text := DateToStr(Empresa.DtCadastro);
  Self.FrmCadastro.mskAbertura.Text := DateToStr(Empresa.DtAbertura);
  Self.FrmCadastro.cmbStatus.ItemIndex := Empresa.Status;
  Self.FrmCadastro.edtAlias.Text := Empresa.Alias;
  Self.FrmCadastro.mskTelefone.Text := Empresa.Telefone;
  Self.FrmCadastro.mskFoneFax.Text := Empresa.FoneFax;
  Self.FrmCadastro.mskCNPJ.Text := Empresa.CNPJ;
  Self.FrmCadastro.edtIE.Text := Empresa.IE;
  Self.FrmCadastro.edtIM.Text := Empresa.IM;
  Self.FrmCadastro.edtIEST.Text := Empresa.IEST;
  Self.FrmCadastro.edtEmail.Text := Empresa.Email;
  Self.FrmCadastro.edtPagina.Text := Empresa.Pagina;
  Self.FrmCadastro.cmbCRT.ItemIndex := Empresa.Crt;
  Self.FrmCadastro.edtCNAE.Text := Empresa.Cnae;
  Self.FrmCadastro.memoObservacao.Text := Empresa.Observacao;
  Self.FrmCadastro.edtContato.Text := Empresa.Contato;

  // endereco
  Self.FrmCadastro.edtLogradouro.Text := Empresa.Endereco.Logradouro;
  Self.FrmCadastro.edtNumero.Text := Empresa.Endereco.Numero;
  Self.FrmCadastro.edtComplemento.Text := Empresa.Endereco.Complemento;
  Self.FrmCadastro.edtBairro.Text := Empresa.Endereco.Bairro;
  Self.FrmCadastro.edtCidade.Text := Empresa.Endereco.Cidade;
  Self.FrmCadastro.mskCEP.Text := Empresa.Endereco.Cep;
  Self.FrmCadastro.edtPontoReferencia.Text := Empresa.Endereco.Referencia;
  Self.FrmCadastro.cmbTipoEndereco.ItemIndex := Empresa.Endereco.Tipo;
  Self.FrmCadastro.chkEnderecoCorresp.Checked := Empresa.Endereco.Correspondencia;

  Self.FrmCadastro.edtFantasia.SetFocus;
end;

function TEmpresaCTR._AddRef: Integer;
begin
  // não implementado, apenas declarado (Interface-Delphi)
end;

function TEmpresaCTR._Release: Integer;
begin
  // não implementado, apenas declarado (Interface-Delphi)
end;

end.
