unit untControleEstoque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons, Mask, clEstoque, clProduto;

type
  TFrmControleEstoque = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtCodigo: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    lblDescricao: TLabel;
    lblUnidade: TLabel;
    lblMarca: TLabel;
    DBGrid1: TDBGrid;
    btnFechar: TBitBtn;
    GroupBox1: TGroupBox;
    rdgTipo: TRadioGroup;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    btnPesquisar: TBitBtn;
    mskData: TMaskEdit;
    edtDocumento: TEdit;
    edtValorCusto: TEdit;
    edtQuantidade: TEdit;
    edtSaldo: TEdit;
    Label8: TLabel;
    btnMovimentar: TBitBtn;
    cmbEmpresa: TComboBox;
    Label10: TLabel;
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure rdgTipoClick(Sender: TObject);
    procedure btnMovimentarClick(Sender: TObject);
    procedure cmbEmpresaChange(Sender: TObject);
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure LimparMovimento;
    { Private declarations }
  public
    { Public declarations }
    ProdutoRef: TProduto;
  end;

var
  FrmControleEstoque: TFrmControleEstoque;
  Estoque: TEstoque;

implementation

uses dmConexao, clUtil, clUnidade, DB, ZDataset, clEmpresa;

{$R *.dfm}

procedure TFrmControleEstoque.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmControleEstoque.FormShow(Sender: TObject);
begin
  Estoque := TEstoque.Create;
  edtCodigo.SetFocus;
  GroupBox1.Visible := false;

  lblDescricao.Caption := '';
  lblUnidade.Caption := '';
  lblMarca.Caption := '';
  {
  // populando combobox empresa
  if Estoque.Empresa.getObjects() then begin
    cmbEmpresa.Items.Clear;

    while NOT Conexao.QryGetObject.Eof do begin
      cmbEmpresa.Items.Add(Conexao.QryGetObject.FieldByName('EMP_RAZAO').AsString);
      Conexao.QryGetObject.Next;
    end;
  end;
   }
  // verificamos se a chamada está vindo do formúlario de produto
  // pois o produto pode já estar instanciado em memoria
  if ProdutoRef <> nil then begin
    edtCodigo.Text := ProdutoRef.Codigo;
    cmbEmpresa.ItemIndex := 2; // selecionando a primeira empresa do combobox, por padrão
    cmbEmpresaChange(Self);
  end
  else begin
    //
    if TUtil.NotEmpty(edtCodigo.Text) then
      Estoque.getObjects(edtCodigo.Text);
  end;
end;

procedure TFrmControleEstoque.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TFrmControleEstoque.btnPesquisarClick(Sender: TObject);
begin
  if cmbEmpresa.ItemIndex = -1 then begin
    edtCodigo.Clear;
    ShowMessage('Deve-se selecionar uma empresa antes de realizar a busca pelo Produto!');
    cmbEmpresa.SetFocus;
    Exit;
  end;

  if TUtil.NotEmpty(edtCodigo.Text) then begin
    //
    if Estoque.Produto.getObject(Trim(edtCodigo.Text)) then begin
      lblDescricao.Caption := Estoque.Produto.Descricao;
      lblMarca.Caption := Estoque.Produto.Marca.getField('MAR_DESCRICAO', 'CODIGO');
      lblUnidade.Caption := Estoque.Produto.Unidade.getField('UND_SIGLA', 'CODIGO');
      edtSaldo.Text := FormatFloat('0.00', Estoque.ConsultarSaldo());

      // 
      Estoque.getObjects(Estoque.Produto.Codigo);

      //
      GroupBox1.Visible := true;
      btnMovimentar.Enabled := false;
      mskData.Text := DateToStr(Date);
    end;
  end;
end;

procedure TFrmControleEstoque.rdgTipoClick(Sender: TObject);
begin
  if TUtil.NotEmpty(Estoque.Produto.Codigo) then begin
    case rdgTipo.ItemIndex of
      0 : btnMovimentar.Caption := 'Mov. Entrada';
      1 : btnMovimentar.Caption := 'Mov. Saída';
    end;
    btnMovimentar.Enabled := True;
    edtQuantidade.SetFocus;
  end;
end;

procedure TFrmControleEstoque.btnMovimentarClick(Sender: TObject);
begin
  if MessageBox(Application.Handle, 'Deseja Realmente Movimentar o Estoque?', 'Controle Estoque', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = ID_NO then
    Exit;

  case rdgTipo.ItemIndex of
    0 : Estoque.TipoMov := 'E';
    1 : Estoque.TipoMov := 'S';
  end;

  //
  Estoque.Data := StrToDate(mskData.Text);
  Estoque.Quantidade := StrToFloat(edtQuantidade.Text);
  Estoque.VlrCusto := StrToFloat(edtValorCusto.Text);
  Estoque.Documento := edtDocumento.Text;

  if Estoque.Validar() then
    if Estoque.Movimentacao() then
      LimparMovimento
    else
      ShowMessage('Problemas ao Efeturar Movimentação no Estoque!');
end;

procedure TFrmControleEstoque.LimparMovimento;
begin
  Estoque.getObjects(edtCodigo.Text);
  edtSaldo.Text := FormatFloat('0.00', Estoque.ConsultarSaldo());
  rdgTipo.ItemIndex := -1;
  btnMovimentar.Enabled := false;

  // limpar campos
  edtQuantidade.Clear;
  edtValorCusto.Clear;
  edtDocumento.Clear;
end;

procedure TFrmControleEstoque.cmbEmpresaChange(Sender: TObject);
begin
  Estoque.Empresa.Razao := cmbEmpresa.Text;
  //Estoque.Empresa.Codigo := Estoque.Empresa.getField('EMP_CODIGO', 'RAZAO');

  if TUtil.NotEmpty(edtCodigo.Text) then
    btnPesquisarClick(Self);
end;

procedure TFrmControleEstoque.edtCodigoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnPesquisarClick(Self);
end;

end.
