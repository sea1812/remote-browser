unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, cyPanel, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, Menus, nkTitleBar, nkResizer,
  VirtualTrees, rxctrls, BCLabel, gogopluginss;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    BCLabel1: TBCLabel;
    CyPanel1: TCyPanel;
    ImageList1: TImageList;
    ImageList2: TImageList;
    ListRemotes: TListView;
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
    procedure InitPlugins;
    procedure InitPopAddRemote;
    procedure PopAddRemoteClick(Sender: TObject);
    procedure ReloadListRemotes;
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
  Hide;
  Dm.Plugins.Clear;
  //Dm.Plugins.Free;
  Close;
//  Application.Terminate;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  InitDB;
  InitPlugins;
  InitPopAddRemote;
  RxSpeedButton2Click(nil);
  ReloadListRemotes;
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
  mPlugin:=TGoGoPluginItem.Create(Self,ExtractFilepath(Application.ExeName)+'\plugin\webdav.dll');
// -----------------------------
//  m:=mPlugin.PlugInfo();
//  ShowMessage('Plugin.PlugInfo 说: '+#10#13+#10#13+m);
//  mPlugin.Free;
//  mPlugin:=nil;
// -----------------------------
  m:=mPlugin.Edit(Self.Handle,Dm.conn);
  //showmessage(m);
  //窗口自释放，无需mPlugin.Free;
  // -----------------------------

end;

procedure TfrmMain.InitDB;
begin
  dm.conn.LibraryLocation:=ExtractFilepath(Application.ExeName)+'\data\sqlite3.dll';
  dm.conn.Database:=ExtractFilepath(Application.ExeName)+'\data\config.db';
  dm.conn.Connect;
end;

procedure TfrmMain.InitPlugins;
var
  mFiles:TStrings;
  i:integer;
  mItem:TGoGoPluginItem;
  mInfo:string;
  m:string;
begin
  dm.Plugins:=TGoGoPlugins.Create(Self);
  //查找plugin目录下的插件Dll
  mFiles := FindAllFiles(ExtractFilepath(Application.ExeName)+'plugin', '*.dll', False);
  for i:=0 to mFiles.Count-1 do
  begin
    mItem:=TGoGoPluginItem.Create(Self,Trim(mFiles.Strings[i]));
    m:=mItem.PlugType();
    mInfo := m;
    mItem.LibType:=mInfo;
    Dm.Plugins.Add(mItem);
  end;
  mFiles.Free;
  //测试
  //if Dm.Plugins.Count>0 then
  //begin
  //  ShowMessage(Dm.Plugins.Item(0).LibType);
  //end;
end;

procedure TfrmMain.InitPopAddRemote;
var
  i:integer;
  mItem:TMenuItem;
begin
  PopAddRemote.Items.Clear;
  for i:=0 to Dm.Plugins.Count-1 do
  begin
    mItem:=TMenuItem.Create(PopAddRemote);
    mItem.Caption:='添加 '+UpperCase(Dm.Plugins.Item(i).LibType)+' 存储';
    mItem.Tag:=i;
    mItem.OnClick:=@PopAddRemoteClick;
    PopAddRemote.Items.Add(mItem);
  end;
end;

procedure TfrmMain.PopAddRemoteClick(Sender: TObject);
var
  mIndex:integer;
  mResult:string;
begin
  mIndex:=(Sender as TMenuItem).Tag;
  mResult:=dm.Plugins.Item(mIndex).Edit(Self.Handle,Dm.conn);
  if mResult='OK' then
  begin
    //窗口返回mrOK，刷新目录列表
    ReloadListRemotes;
  end;
end;

procedure TfrmMain.ReloadListRemotes;
begin
  ListRemotes.Items.BeginUpdate;
  ListRemotes.Items.Clear;
  with dm.InnerQry do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select * from remotes2 order by rname asc');
    Open;
    First;
    while not Eof do
    begin
      with ListRemotes.Items.Add do
      begin
        Caption:='';//FieldByName('rtype').AsString;
        SubItems.Add(FieldByName('rname').AsString);
        if Trim(FieldByName('rletter').AsString)='' then
          SubItems.Add('-')
        else
          SubItems.Add(FieldByName('rletter').AsString);
        SubItems.Add(FieldByName('rcomment').AsString);
        SubItems.Add(inttostr(FieldByName('id').AsInteger));
        ImageIndex:=0;
      end;
      Next;
    end;
  end;
  listRemotes.Items.EndUpdate;
end;

end.

