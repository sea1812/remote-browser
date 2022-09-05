unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, cyPanel, cyNavPanel, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, Menus, nkTitleBar, nkResizer, FZCommon, FZBase,
  TplTabControlUnit, vte_treedata, VirtualTrees, rxctrls, BCLabel, gogopluginss,
  Base64;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    BCLabel1: TBCLabel;
    CyPanel1: TCyPanel;
    ImageList1: TImageList;
    ListView1: TListView;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    nkResizer2: TnkResizer;
    nkTitleBar2: TnkTitleBar;
    PageControl1: TPageControl;
    Panel1: TPanel;
    PopAddRemote: TPopupMenu;
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
    procedure FormShow(Sender: TObject);
    procedure RxSpeedButton1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure RxSpeedButton3Click(Sender: TObject);
    procedure ToolHelpClick(Sender: TObject);
  private
    WinMax : boolean;
    OldLeft,OldTop,OldWidth,OldHeight:integer;

  public
    procedure InitDB;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  datamodule;
{$R *.frm}

{ TfrmMain }

procedure TfrmMain.RxSpeedButton1Click(Sender: TObject);
begin
  //Hide;
  Close;
  //Application.Terminate;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  InitDB;
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

procedure TfrmMain.ToolHelpClick(Sender: TObject);
var
  mPlugin:TGoGoPluginItem;
  m:string;
begin
  //测试plugin
  mPlugin:=TGoGoPluginItem.Create(Self,ExtractFilepath(Application.ExeName)+'webdav.dll');
// -----------------------------
//  m:=mPlugin.PlugInfo();
//  ShowMessage('Plugin.PlugInfo 说: '+#10#13+#10#13+AnsiToUTF8(DecodeStringBase64(m)));
//  mPlugin.Free;
//  mPlugin:=nil;
// -----------------------------
  m:=mPlugin.Edit(Self.Handle,Dm.conn);
  showmessage(m);
  //窗口自释放，无需mPlugin.Free;
  // -----------------------------

end;

procedure TfrmMain.InitDB;
begin
  dm.conn.LibraryLocation:=ExtractFilepath(Application.ExeName)+'sqlite3.dll';
  dm.conn.Database:=ExtractFilepath(Application.ExeName)+'config.db';
  dm.conn.Connect;
end;

end.

