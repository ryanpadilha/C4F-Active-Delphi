unit untPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls;

type
  TFrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastros1: TMenuItem;
    GrupodeEmpresas1: TMenuItem;
    Produtos1: TMenuItem;
    CadastrodeProduto1: TMenuItem;
    CadastrodeMarca1: TMenuItem;
    CadastrodeUnidade1: TMenuItem;
    CadastrodeCategoria1: TMenuItem;
    Movimentao1: TMenuItem;
    MovimentaodeEstoque1: TMenuItem;
    Sobre1: TMenuItem;
    StatusBar1: TStatusBar;
    Image1: TImage;
    procedure Sobre1Click(Sender: TObject);
    procedure GrupodeEmpresas1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CadastrodeProduto1Click(Sender: TObject);
    procedure MovimentaodeEstoque1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses untAbout, untCadastroEmpresa, dmConexao, untCadastroProduto,
  untControleEstoque, clEmpresaCTR;

{$R *.dfm}

procedure TFrmPrincipal.Sobre1Click(Sender: TObject);
begin
  if NOT Assigned(FrmAbout) then
    FrmAbout := TFrmAbout.Create(Application);
  FrmAbout.ShowModal;
end;

procedure TFrmPrincipal.GrupodeEmpresas1Click(Sender: TObject);
var
  EmpresaCTR : TEmpresaCTR;
begin
  {
  -- Invocação de Formulário sem o Padrão MVC

  if NOT Assigned(FrmCadastroEmpresa) then
    FrmCadastroEmpresa := TFrmCadastroEmpresa.Create(Application);
  FrmCadastroEmpresa.ShowModal;
  }

  // Aplicação do Padrão de Projeto MVC
  // controller - Empresa
  EmpresaCTR := TEmpresaCTR.Create;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  // efetuando a conexão com o banco de dados
  if NOT Conexao.ZConnection.Connected then begin
    Conexao.ZConnection.Connected := false;

    Conexao.ZConnection.Database := 'ActiveDelphi';
    Conexao.ZConnection.Connected := true;
  end;
end;

procedure TFrmPrincipal.FormActivate(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := ' Banco de Dados: '+ Conexao.ZConnection.Database;

  if Conexao.ZConnection.Connected then
    StatusBar1.Panels[1].Text := ' Conexão Estabelecida!'
  else
    StatusBar1.Panels[1].Text := ' Conexão Falhou!';
end;

procedure TFrmPrincipal.CadastrodeProduto1Click(Sender: TObject);
begin
  if NOT Assigned(FrmCadastroProduto) then
    FrmCadastroProduto := TFrmCadastroProduto.Create(Application);
  FrmCadastroProduto.ShowModal;
end;

procedure TFrmPrincipal.MovimentaodeEstoque1Click(Sender: TObject);
begin
  if NOT Assigned(FrmControleEstoque) then
    FrmControleEstoque := TFrmControleEstoque.Create(Application);
  FrmControleEstoque.ShowModal;  
end;

end.
