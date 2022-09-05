unit editform;

{$mode objfpc}{$H+}

interface

uses
  Interfaces, Classes, SysUtils, FileUtil, cyPanel, ZDataset, Forms, Controls,
  Graphics, StdCtrls, Dialogs, ExtCtrls, nkTitleBar, rxctrls, BCLabel;

type

  { TfrmEdit }

  TfrmEdit = class(TForm)
    BCLabel1: TBCLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    nkTitleBar2: TnkTitleBar;
    Panel1: TPanel;
    Qry: TZQuery;
    RxSpeedButton1: TRxSpeedButton;
    RxSpeedButton2: TRxSpeedButton;
    RxSpeedButton3: TRxSpeedButton;
    StatusBar: TCyPanel;
    StatusBar1: TCyPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
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

procedure TfrmEdit.FormDestroy(Sender: TObject);
begin
  mForm := nil;
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  if ID = 0 then
    BCLabel1.Caption:='添加 WebDav 存储'
  else
    BCLabel1.Caption:='编辑 WebDav 存储';
  Caption:=BCLabel1.Caption;
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

begin
   Application.Initialize;
end.

