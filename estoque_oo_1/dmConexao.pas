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
