unit untCadastroProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Grids, DBGrids, clProduto;

type
  TFrmCadastroProduto = class(TForm)
    Panel1: TPanel;
    sppSalvar: TSpeedButton;
    sppExcluir: TSpeedButton;
    sppCancelar: TSpeedButton;
    sppFechar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtCodigo: TEdit;
    edtCodigoPrinc: TEdit;
    edtDescricao: TEdit;
    edtDescRed: TEdit;
    cmbMarca: TComboBox;
    cmbUnidade: TComboBox;
    cmbStatus: TComboBox;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    btnEstoque: TBitBtn;
    procedure sppFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure sppExcluirClick(Sender: TObject);
    procedure sppCancelarClick(Sender: TObject);
    procedure sppSalvarClick(Sender: TObject);
    procedure cmbMarcaChange(Sender: TObject);
    procedure cmbUnidadeChange(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btnEstoqueClick(Sender: TObject);
  private
    procedure SetupObject;
    procedure SetupMarca(Id: String);
    procedure SetupUnidade(Id: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCadastroProduto: TFrmCadastroProduto;
  Produto: TProduto;

implementation

uses dmConexao, clUtil, DB, untControleEstoque;

{$R *.dfm}

procedure TFrmCadastroProduto.sppFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCadastroProduto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Produto.Free;
  Action := caFree;
  FrmCadastroProduto := nil;
end;

procedure TFrmCadastroProduto.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TFrmCadastroProduto.FormShow(Sender: TObject);
begin
  Produto := TProduto.Create;
  cmbStatus.ItemIndex := 1;

  Conexao.QryProduto.Close;
  Conexao.QryProduto.Open;

  // populando combobox unidade
  if Produto.Unidade.getObjects() then begin
    cmbUnidade.Items.Clear;

    while NOT Conexao.QryGetObject.Eof do begin
      cmbUnidade.Items.Add(Conexao.QryGetObject.FieldByName('UND_SIGLA').AsString);
      Conexao.QryGetObject.Next;
    end;
  end;

  // populando combobox marca
  if Produto.Marca.getObjects() then begin
    cmbMarca.Items.Clear;

    while NOT Conexao.QryGetObject.Eof do begin
      cmbMarca.Items.Add(Conexao.QryGetObject.FieldByName('MAR_DESCRICAO').AsString);
      Conexao.QryGetObject.Next;
    end;
  end;

end;

procedure TFrmCadastroProduto.sppExcluirClick(Sender: TObject);
begin
  if TUtil.Empty(Produto.Codigo) then
    Exit;

  if MessageBox(Application.Handle, 'Deseja Realmente Excluir o Registro?', 'Controle Estoque', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = ID_NO then
    Exit;

  if TUtil.NotEmpty(Produto.Codigo) then begin
    if NOT Produto.Delete then
      ShowMessage('Erro ao Excluir o Registro.')
    else begin
      TUtil.LimparFields(FrmCadastroProduto);
      Conexao.QryProduto.Close;
      Conexao.QryProduto.Open;
    end;
  end;
end;

procedure TFrmCadastroProduto.sppCancelarClick(Sender: TObject);
begin
  TUtil.LimparFields(FrmCadastroProduto);
  Produto := nil;
  Produto := TProduto.Create;
  edtDescricao.SetFocus;
end;

procedure TFrmCadastroProduto.sppSalvarClick(Sender: TObject);
var
  Operacao: String;
begin
  Operacao := 'U';
  Produto.Codigo := edtCodigo.Text;
  Produto.CodigoPrincipal := edtCodigoPrinc.Text;
  Produto.Descricao := edtDescricao.Text;
  Produto.DescReduzido := edtDescRed.Text;

  if cmbStatus.ItemIndex = 0 then
    Produto.Status := false
  else
    Produto.Status := true;

  if TUtil.Empty(Produto.Codigo) then
    Operacao := 'I';

  if Produto.Validar() then
    if Produto.Merge() then begin
      if Operacao = 'I' then
        ShowMessage('Registro Gravado com Sucesso!')
      else
        ShowMessage('Registro Atualizado com Sucesso!');

      Conexao.QryProduto.Close;
      Conexao.QryProduto.Open;
      sppCancelarClick(Self);
    end;
end;

procedure TFrmCadastroProduto.cmbMarcaChange(Sender: TObject);
begin
  Produto.Marca.Descricao := cmbMarca.Text;
  Produto.Marca.Codigo := Produto.Marca.getField('MAR_CODIGO', 'DESCRICAO');
end;

procedure TFrmCadastroProduto.cmbUnidadeChange(Sender: TObject);
begin
  Produto.Unidade.Sigla := cmbUnidade.Text;
  Produto.Unidade.Codigo := Produto.Unidade.getField('UND_CODIGO', 'SIGLA');
end;

procedure TFrmCadastroProduto.SetupObject;
begin
  edtCodigo.Text := Produto.Codigo;
  edtCodigoPrinc.Text := Produto.CodigoPrincipal;
  edtDescricao.Text := Produto.Descricao;
  edtDescRed.Text := Produto.DescReduzido;

  if Produto.Status then
    cmbStatus.ItemIndex := 1
  else
    cmbStatus.ItemIndex := 0;

  SetupMarca(Produto.Marca.Codigo);
  SetupUnidade(Produto.Unidade.Codigo);
end;

procedure TFrmCadastroProduto.DBGrid1CellClick(Column: TColumn);
begin
  Produto.Codigo := Conexao.QryProdutopro_codigo.AsString;
  Produto.CodigoPrincipal := Conexao.QryProdutopro_c_principal.AsString;
  Produto.Descricao := Conexao.QryProdutopro_descricao.AsString;
  Produto.DescReduzido := Conexao.QryProdutopro_desc_reduzido.AsString;
  Produto.Status := Conexao.QryProdutopro_status.AsBoolean;
  Produto.Marca.Codigo := Conexao.QryProdutomar_codigo.AsString;
  Produto.Unidade.Codigo := Conexao.QryProdutound_codigo.AsString;
  // 
  SetupObject();
end;

procedure TFrmCadastroProduto.SetupMarca(Id: String);
var
  i, indice: Integer;
begin
  indice := -1;
  Id := Produto.Marca.getField('MAR_DESCRICAO', 'CODIGO');

  for i := 0 to cmbMarca.Items.Count-1 do begin
    if Id = cmbMarca.Items[i] then
      indice := i;
  end;

  cmbMarca.ItemIndex := indice;
end;

procedure TFrmCadastroProduto.SetupUnidade(Id: String);
var
  i, indice: Integer;
begin
  indice := -1;
  Id := Produto.Unidade.getField('UND_SIGLA', 'CODIGO');

  for i := 0 to cmbUnidade.Items.Count-1 do begin
    if Id = cmbUnidade.Items[i] then
      indice := i;
  end;

  cmbUnidade.ItemIndex := indice;
end;


procedure TFrmCadastroProduto.btnEstoqueClick(Sender: TObject);
begin
  if NOT Assigned(FrmControleEstoque) then
    FrmControleEstoque := TFrmControleEstoque.Create(Application);

  // passando o Objeto Produto para o outro formulário (estoque)
  // em cada formulário encontramos um objeto do tipo produto
  // sendo possível passar o estado de um objeto de um formulário
  // ao objeto de outro formulário
  if TUtil.NotEmpty(Produto.Codigo) then 
    FrmControleEstoque.ProdutoRef := Produto;

  FrmControleEstoque.ShowModal;
end;

end.
