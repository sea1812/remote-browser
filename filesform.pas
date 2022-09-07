unit filesform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, cyPanel, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, formpanel;

type

  { TFilesPanel }

  TFilesPanel = class(TFormPanel)
  private
    FRootpath: string;
    FRAlias: string;
  public
    procedure ShowForm;override;
  published
    property  RAlias:string read FRAlias write FRAlias;
    property  RootPath:string read FRootpath write FRootPath;
  end;

  { TfrmFiles }

  TfrmFiles = class(TForm)
    ComboBox1: TComboBox;
    ListView1: TListView;
    SpeedButton1: TSpeedButton;
    StatusBar1: TCyPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FRootpath: string;
    FrAlias: string;
  public

  published
    property  RAlias:string read FrAlias write FrAlias;
    property  RootPath:string read FRootpath write FRootPath;

  end;

implementation

{$R *.frm}

{ TfrmFiles }

procedure TfrmFiles.SpeedButton1Click(Sender: TObject);
begin
  if Self.Parent is TTabSheet then
  begin
    (Self.Parent as TTabSheet).Free;
  end;
end;

procedure TfrmFiles.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

{ TFilesPanel }

procedure TFilesPanel.ShowForm;
var
  mform:TfrmFiles;
begin
  inherited ShowForm;
  mform:=TfrmFiles.Create(Self);
  mform.Parent:=Self;
  mform.Align:=alClient;
  mform.BorderStyle:=bsNone;
  mform.RAlias:=Self.RAlias;
  mForm.RootPath:=Self.RootPath;
  mform.Show;
end;

end.

