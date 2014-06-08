program ControleEstoque;

uses
  Forms,
  untPrincipal in 'untPrincipal.pas' {FrmPrincipal},
  untAbout in 'untAbout.pas' {FrmAbout},
  clEndereco in 'classes\clEndereco.pas',
  dmConexao in 'dmConexao.pas' {Conexao: TDataModule},
  clPessoa in 'classes\clPessoa.pas',
  clPessoaJ in 'classes\clPessoaJ.pas',
  clEmpresa in 'classes\clEmpresa.pas',
  clUtil in 'clUtil.pas',
  untCadastroEmpresa in 'view\untCadastroEmpresa.pas' {FrmCadastroEmpresa},
  untCadastroProduto in 'view\untCadastroProduto.pas' {FrmCadastroProduto},
  clProduto in 'classes\clProduto.pas',
  clUnidade in 'classes\clUnidade.pas',
  clMarca in 'classes\clMarca.pas',
  untControleEstoque in 'view\untControleEstoque.pas' {FrmControleEstoque},
  clEstoque in 'classes\clEstoque.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmAbout, FrmAbout);
  Application.CreateForm(TConexao, Conexao);
  Application.CreateForm(TFrmCadastroEmpresa, FrmCadastroEmpresa);
  Application.CreateForm(TFrmCadastroProduto, FrmCadastroProduto);
  Application.CreateForm(TFrmControleEstoque, FrmControleEstoque);
  Application.Run;
end.
