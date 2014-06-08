unit untCadastroEmpresa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Mask;

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
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCadastroEmpresa: TFrmCadastroEmpresa;

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
  mskCadastro.Text := TUtil.Sysdate;
  cmbStatus.ItemIndex := 1;
  cmbCRT.ItemIndex := 2;
  cmbTipoEndereco.ItemIndex := 1; // comercial
  edtFantasia.SetFocus;
end;

end.
