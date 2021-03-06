unit untCadastroEmpresa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Mask, clEmpresa;

type
  TFrmCadastroEmpresa = class(TForm)
    Panel1: TPanel;
    sppSalvar: TSpeedButton;
    sppExcluir: TSpeedButton;
    sppPesquisar: TSpeedButton;
    sppCancelar: TSpeedButton;
    sppFechar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label14: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label7: TLabel;
    Label13: TLabel;
    Label24: TLabel;
    Label12: TLabel;
    Label25: TLabel;
    edtCodigo: TEdit;
    edtFantasia: TEdit;
    edtRazao: TEdit;
    mskAbertura: TMaskEdit;
    mskCadastro: TMaskEdit;
    mskTelefone: TMaskEdit;
    mskFoneFax: TMaskEdit;
    cmbStatus: TComboBox;
    edtAlias: TEdit;
    edtIM: TEdit;
    edtEmail: TEdit;
    edtIEST: TEdit;
    edtIE: TEdit;
    mskCnpj: TMaskEdit;
    edtPagina: TEdit;
    edtCNAE: TEdit;
    memoObservacao: TMemo;
    cmbCRT: TComboBox;
    edtContato: TEdit;
    GroupBoxEndereco: TGroupBox;
    Label15: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label27: TLabel;
    Label26: TLabel;
    edtLogradouro: TEdit;
    edtNumero: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtPontoReferencia: TEdit;
    mskCep: TMaskEdit;
    cmbTipoEndereco: TComboBox;
    chkEnderecoCorresp: TCheckBox;
    procedure sppFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure sppSalvarClick(Sender: TObject);
    procedure sppCancelarClick(Sender: TObject);
    procedure sppExcluirClick(Sender: TObject);
    procedure sppPesquisarClick(Sender: TObject);
  private
    procedure SetupObject;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCadastroEmpresa: TFrmCadastroEmpresa;
  Empresa: TEmpresa;   // declara��o do objeto do Tipo TEmpresa

implementation

uses clUtil;

{$R *.dfm}

procedure TFrmCadastroEmpresa.sppFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCadastroEmpresa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Empresa.Free;
  Action := caFree;
  FrmCadastroEmpresa := nil;
end;

procedure TFrmCadastroEmpresa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_UP              : Perform(WM_NEXTDLGCTL, 1, 0);
    VK_DOWN, VK_RETURN : Perform(WM_NEXTDLGCTL, 0, 0);
    027 : Close;
    112 : ;// F1
    113 : ;// F2
    114 : ;// F3
    115 : ;// F4
    116 : ;// F5
    117 : ;// F6
    118 : ;// F7
    119 : ;// F8
    120 : ;// F9
    121 : ;// F10
    122 : ;// F11
    123 : ;// F12
  end;
end;

procedure TFrmCadastroEmpresa.FormShow(Sender: TObject);
begin
  Empresa := TEmpresa.Create;  // Instancia��o do objeto Empresa na mem�ria HEAP!
  mskCadastro.Text := TUtil.Sysdate;
  cmbStatus.ItemIndex := 1;
  cmbCRT.ItemIndex := 2;
  cmbTipoEndereco.ItemIndex := 1; // comercial
  edtFantasia.SetFocus;
end;

procedure TFrmCadastroEmpresa.sppSalvarClick(Sender: TObject);
var
  Operacao: String;
begin
  Operacao := 'U';
  Empresa.Codigo := edtCodigo.Text;
  Empresa.Razao := edtRazao.Text;
  Empresa.Fantasia := edtFantasia.Text;
  Empresa.DtAbertura := StrToDate(mskAbertura.Text);
  Empresa.DtCadastro := StrToDate(mskCadastro.Text);
  Empresa.Status := cmbStatus.ItemIndex;
  Empresa.Alias := edtAlias.Text;

  // telefones
  Empresa.Telefone := mskTelefone.Text;
  Empresa.FoneFax := mskFoneFax.Text;

  // documentos
  Empresa.CNPJ := mskCNPJ.Text;
  Empresa.IE := edtIE.Text;
  Empresa.IM := edtIM.Text;
  Empresa.IEST := edtIEST.Text;

  Empresa.Email := edtEmail.Text;
  Empresa.Pagina := edtPagina.Text;
  Empresa.Crt := cmbCRT.ItemIndex;
  Empresa.Cnae := edtCNAE.Text;
  Empresa.Contato := edtContato.Text;
  Empresa.Observacao := memoObservacao.Text;
  Empresa.Contato := edtContato.Text;

  // endereco
  Empresa.Endereco.Correspondencia := chkEnderecoCorresp.Checked;
  Empresa.Endereco.Logradouro := edtLogradouro.Text;
  Empresa.Endereco.Numero := edtNumero.Text;
  Empresa.Endereco.Complemento := edtComplemento.Text;
  Empresa.Endereco.Bairro := edtBairro.Text;
  Empresa.Endereco.Cidade := edtCidade.Text;
  Empresa.Endereco.Cep := mskCEP.Text;
  Empresa.Endereco.Referencia := edtPontoReferencia.Text;
  Empresa.Endereco.Tipo := cmbTipoEndereco.ItemIndex;

  if TUtil.Empty(Empresa.Codigo) then
    Operacao := 'I';

  if Empresa.Validar() then
    if Empresa.Merge() then begin
      TUtil.LimparFields(FrmCadastroEmpresa);

      if Operacao = 'I' then
        ShowMessage('Registro Gravado com Sucesso!')
      else
        ShowMessage('Registro Atualizado com Sucesso!');

      edtFantasia.SetFocus;
    end;
end;

procedure TFrmCadastroEmpresa.sppCancelarClick(Sender: TObject);
begin
  TUtil.LimparFields(FrmCadastroEmpresa);
  Empresa := nil;
  Empresa := TEmpresa.Create;
  edtFantasia.SetFocus;
end;

procedure TFrmCadastroEmpresa.sppExcluirClick(Sender: TObject);
begin
  if TUtil.Empty(Empresa.Codigo) then
    Exit;

  if MessageBox(Application.Handle, 'Deseja Realmente Excluir o Registro?', 'Controle Estoque', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = ID_NO then
    Exit;

  if TUtil.NotEmpty(Empresa.Codigo) then begin
    if NOT Empresa.Delete then
      ShowMessage('Erro ao Excluir o Registro.')
    else
      sppCancelarClick(Self);
  end;
end;

procedure TFrmCadastroEmpresa.SetupObject;
begin
  edtCodigo.Text := Empresa.Codigo;
  edtFantasia.Text := Empresa.Fantasia;
  edtRazao.Text := Empresa.Razao;
  mskCadastro.Text := DateToStr(Empresa.DtCadastro);
  mskAbertura.Text := DateToStr(Empresa.DtAbertura);
  cmbStatus.ItemIndex := Empresa.Status;
  edtAlias.Text := Empresa.Alias;
  mskTelefone.Text := Empresa.Telefone;
  mskFoneFax.Text := Empresa.FoneFax;
  mskCNPJ.Text := Empresa.CNPJ;
  edtIE.Text := Empresa.IE;
  edtIM.Text := Empresa.IM;
  edtIEST.Text := Empresa.IEST;
  edtEmail.Text := Empresa.Email;
  edtPagina.Text := Empresa.Pagina;
  cmbCRT.ItemIndex := Empresa.Crt;
  edtCNAE.Text := Empresa.Cnae;
  memoObservacao.Text := Empresa.Observacao;
  edtContato.Text := Empresa.Contato;

  // endereco
  edtLogradouro.Text := Empresa.Endereco.Logradouro;
  edtNumero.Text := Empresa.Endereco.Numero;
  edtComplemento.Text := Empresa.Endereco.Complemento;
  edtBairro.Text := Empresa.Endereco.Bairro;
  edtCidade.Text := Empresa.Endereco.Cidade;
  mskCEP.Text := Empresa.Endereco.Cep;
  edtPontoReferencia.Text := Empresa.Endereco.Referencia;
  cmbTipoEndereco.ItemIndex := Empresa.Endereco.Tipo;
  chkEnderecoCorresp.Checked := Empresa.Endereco.Correspondencia;

  edtFantasia.SetFocus;
end;



procedure TFrmCadastroEmpresa.sppPesquisarClick(Sender: TObject);
begin
{
  O evento de pesquisa N�O foi implementado, pois ainda n�o foi citado no artigo como realizamos a pesquisa.
  No artigo (parte II) n�o foi citado nenhum formul�rio de pesquisa, e o mesmo deve ser criado para efetuar a pesquisa.

  O leitor tem a liberdade de implementar a pesquisa conforme sua necessidade.
  Qualquer d�vida entrar em contato com o colunista.
}
end;

end.
