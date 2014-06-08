unit IController;

interface

type
  Controller = interface
    procedure Inicializar;
    procedure SalvarClick(Sender: TObject);
    procedure CancelarClick(Sender: TObject);
    procedure ExcluirClick(Sender: TObject);
    procedure PesquisarClick(Sender: TObject);
    procedure SetupObject;
  end;

implementation

end.
