unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, cyPanel, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, nkTitleBar, nkResizer, vte_treedata, VirtualTrees,
  rxctrls, BCLabel;

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
  private

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

end.

