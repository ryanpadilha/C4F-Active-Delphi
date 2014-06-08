unit dmConexao;

interface

uses
  SysUtils, Classes, ZConnection, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset;

type
  TConexao = class(TDataModule)
    ZConnection: TZConnection;
    QryCRUD: TZQuery;
    QryGetObject: TZQuery;
    QryGeral: TZQuery;
    QryProduto: TZQuery;
    QryEstoque: TZQuery;
    dsProduto: TDataSource;
    dsEstoque: TDataSource;
    QryProdutopro_codigo: TIntegerField;
    QryProdutopro_status: TBooleanField;
    QryProdutopro_descricao: TStringField;
    QryProdutopro_desc_reduzido: TStringField;
    QryProdutomar_codigo: TIntegerField;
    QryProdutound_codigo: TIntegerField;
    QryEstoqueest_codigo: TIntegerField;
    QryEstoquepro_codigo: TIntegerField;
    QryEstoqueest_data: TDateField;
    QryEstoqueest_hora: TTimeField;
    QryEstoqueest_documento: TStringField;
    QryEstoqueest_saldo: TFloatField;
    QryEstoqueest_vlr_custo: TFloatField;
    QryEstoqueest_tipo_mov: TStringField;
    QryEstoqueest_quantidade: TFloatField;
    QryEstoqueest_flag: TBooleanField;
    QryProdutopro_c_principal: TStringField;
    QryEstoqueemp_codigo: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Conexao: TConexao;

implementation

{$R *.dfm}

end.
