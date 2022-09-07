unit filesform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, cyPanel, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, formpanel, rccmd, fpjson, jsonparser;

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
    ComboPath: TComboBox;
    ListFiles: TListView;
    SpeedButton1: TSpeedButton;
    StatusBar1: TCyPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FCurrentPath: string;
    FRootpath: string;
    FrAlias: string;
  public
    procedure ListAndFill;
  published
    property  RAlias:string read FrAlias write FrAlias;
    property  RootPath:string read FRootpath write FRootPath;
    property  CurrentPath:string read FCurrentPath write FCurrentPath;

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

procedure TfrmFiles.ListAndFill;
var
  m:string;
  mTmp:TStrings;
  mStream:TMemoryStream;
  mData : TJsonData;
  mArray:TJsonArray;
  i:integer;
  mItem:TJsonData;
begin
  //列出远端文件
  m:=RemoteLsjson(Self.RAlias,CurrentPath);
  //解析JSON
  mTmp:=TStringList.Create;
  mTmp.Text:=m;
  mStream:=TMemoryStream.Create;
  mTmp.SaveToStream(mStream);
  mStream.Seek(0,soBeginning);
  try
    mData := GetJSon(mStream);
  Except
    mData := nil;
  end;
  mStream.Free;
  mTmp.Free;
  if mData<>nil then
  begin
    mArray := TJsonArray(mData);
    ListFiles.Items.BeginUpdate;
    ListFiles.Items.Clear;
    for i:=0 to mArray.Count-1 do
    begin
      mItem := mArray.Items[i];
      with ListFiles.Items.Add do
      begin
        Caption:=mITem.FindPath('Name').AsString;
        SubItems.Add(mItem.FindPath('ModTime').AsString);
        SubItems.Add(mItem.FindPath('MimeType').AsString);
        if Trim(mItem.FindPath('IsDir').AsString)='True' then
          SubItems.Add('')
        else
          SubItems.Add(mItem.FindPath('Size').AsString);

      end;
    end;
    ListFiles.Items.EndUpdate;
  end
  else
  begin
    ShowMessage(m);
  end;
end;

procedure TfrmFiles.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TfrmFiles.FormShow(Sender: TObject);
begin
  if Trim(RootPath)='' then RootPath:='/';
  CurrentPath:=RootPath;
  ComboPath.Text:=CurrentPath;
  if ComboPath.Items.IndexOf(CurrentPath)<0 then
    ComboPath.Items.Add(CurrentPath);
  //检查Alias是否存在
  if RemoteExists(Self.RAlias)=False then
  begin
    MessageDlg('远端存储不存在，或无法连接。',mtError,[mbOK],0);
    Exit;
  end;
  ListAndFill;
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

