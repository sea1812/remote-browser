unit formpanel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, ComCtrls;

type
    { TFormPanel }

  TFormPanel = class(TTabSheet)
  protected
    procedure DoHide; override;
    procedure DoShow; override;
  public
    fForm:TForm;
    procedure ShowForm;virtual;
  end;


implementation

{ TFormPanel }

procedure TFormPanel.DoHide;
begin
  inherited DoHide;
  If Assigned(fForm) then fForm.Hide;
end;

procedure TFormPanel.DoShow;
begin
  inherited DoShow;
  If Assigned(fForm) then fForm.Show;
end;

procedure TFormPanel.ShowForm;
begin

end;

end.

