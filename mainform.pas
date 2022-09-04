unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, cyPanel, cyNavPanel, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, nkTitleBar, nkResizer, FZCommon, FZBase,
  TplTabControlUnit, vte_treedata, VirtualTrees, rxctrls, BCLabel;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    BCLabel1: TBCLabel;
    CyPanel1: TCyPanel;
    ImageList1: TImageList;
    ListView1: TListView;
    nkResizer2: TnkResizer;
    nkTitleBar2: TnkTitleBar;
    PageControl1: TPageControl;
    Panel1: TPanel;
    RxSpeedButton1: TRxSpeedButton;
    RxSpeedButton2: TRxSpeedButton;
    RxSpeedButton3: TRxSpeedButton;
    Splitter1: TSplitter;
    StatusBar: TCyPanel;
    StatusBar1: TCyPanel;
    TabSheet1: TTabSheet;
    ToolAddNode: TToolButton;
    ToolAddRemote: TToolButton;
    ToolAddUSer: TToolButton;
    ToolAddUsers: TToolButton;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolDeleteNode: TToolButton;
    ToolDeleteRemote: TToolButton;
    ToolDeleteUser: TToolButton;
    ToolEditNode: TToolButton;
    ToolEditRemote: TToolButton;
    ToolEditUser: TToolButton;
    ToolHelp: TToolButton;
    ToolNodeLicense: TToolButton;
    ToolStartNode: TToolButton;
    ToolStopNode: TToolButton;
    ToolSyncAll: TToolButton;
    ToolSyncData: TToolButton;
    procedure RxSpeedButton1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure RxSpeedButton3Click(Sender: TObject);
  private
    WinMax : boolean;
    OldLeft,OldTop,OldWidth,OldHeight:integer;

  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.frm}

{ TfrmMain }

procedure TfrmMain.RxSpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.RxSpeedButton2Click(Sender: TObject);
begin
  if WinMax = False then
  begin
    OldLeft := Self.Left;
    OldTop  := Self.Top;
    OldWidth := Self.Width;
    OldHeight := Self.Height;
    Self.Top:=Self.Monitor.WorkareaRect.Top;
    Self.Left:=Self.Monitor.WorkareaRect.Left;
    Self.Width:=Self.Monitor.WorkareaRect.Width;
    Self.Height:=Self.Monitor.WorkareaRect.Height;
    WinMax := True;
  end
  else
  begin
    Self.Top:=OldTop;
    Self.Left:=OldLeft;
    Self.Width:=OldWidth;
    Self.Height:=OldHeight;
    WinMax := False;
  end;
end;

procedure TfrmMain.RxSpeedButton3Click(Sender: TObject);
begin
  Application.Minimize;
end;

end.

