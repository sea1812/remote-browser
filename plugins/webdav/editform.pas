unit editform;

{$mode objfpc}{$H+}

interface

uses
  Interfaces, Classes, SysUtils, FileUtil, cyPanel, ZDataset, Forms, Controls,
  Graphics, StdCtrls, Dialogs, nkTitleBar, rxctrls, BCLabel;

type

  { TfrmEdit }

  TfrmEdit = class(TForm)
    BCLabel1: TBCLabel;
    Button1: TButton;
    nkTitleBar2: TnkTitleBar;
    Qry: TZQuery;
    RxSpeedButton1: TRxSpeedButton;
    RxSpeedButton2: TRxSpeedButton;
    RxSpeedButton3: TRxSpeedButton;
    StatusBar: TCyPanel;
    StatusBar1: TCyPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RxSpeedButton1Click(Sender: TObject);
  private

  public
    ID:integer;
  end;

var
  mForm:TfrmEdit;

implementation

{$R *.frm}

{ TfrmEdit }

procedure TfrmEdit.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  if ID = 0 then
    BCLabel1.Caption:='新增WebDav存储'
  else
    BCLabel1.Caption:='编辑WebDav存储'
end;

procedure TfrmEdit.RxSpeedButton1Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmEdit.Button1Click(Sender: TObject);
begin
  if Qry.Connection.Connected then
  begin
    with qry do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select count(*) as aa from users');
      Open;
      First;
      if not Eof then
      begin
        ShowMessage(inttostr(FieldByName('aa').AsInteger));
      end;
    end;
  end;
end;

end.

