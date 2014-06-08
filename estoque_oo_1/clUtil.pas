unit clUtil;

{
  Definicao da Classe Util
  Contem rotinas gerais para os modulos

  @autor  Ryan Bruno C Padilha (ryan.padilha@gmail.com)
  @version 0.1 (02/01/2010)

}

interface

uses Forms, StdCtrls, Mask, ExtCtrls, FileCtrl, Dialogs;

type
  TUtil = class(TObject)
  private

  protected

  public
    class function Empty(texto: String): Boolean;
    class function NotEmpty(texto: String): Boolean;
    class function Sysdate(): String;
    class procedure LimparFields(Form: TForm);
  end;

implementation

uses SysUtils;

{ TUtil }

class function TUtil.Empty(texto: String): Boolean;
begin
  if (Length(Trim(texto)) = 0) OR (Trim(texto) = '  /  /') then
    Result := True
  else
    Result := False;
end;

class procedure TUtil.LimparFields(Form: TForm);
var
  i : integer;
begin
  for i:=0 to Form.ComponentCount-1 do begin
    // componentes VCL
    if Form.Components[i] is TEdit then
      (Form.Components[i] as TEdit).Clear;

    if Form.Components[i] is TComboBox then
      (Form.Components[i] as TComboBox).ItemIndex := -1;

    if Form.Components[i] is TMemo then
      (Form.Components[i] as TMemo).Clear;

    if Form.Components[i] is TMaskEdit then
      (Form.Components[i] as TMaskEdit).Clear;

    if Form.Components[i] is TImage then
      (Form.Components[i] as TImage).Picture := NIL;
  end;
end;

class function TUtil.NotEmpty(texto: String): Boolean;
begin
  if Empty(texto) then
    Result := False
  else
    Result := True;
end;

class function TUtil.Sysdate: String;
begin
  Result := DateToStr(Date);
end;

end.
