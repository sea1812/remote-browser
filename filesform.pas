unit filesform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, cyPanel, Forms, Controls, Graphics, Dialogs, LCLIntf, LCLType,
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
    procedure ComboPathKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ComboPathSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListFilesDblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FCurrentPath: string;
    FRootpath: string;
    FrAlias: string;
    FValidPath: string;
  public
    function ListAndFill:boolean;
    procedure AddPath;
  published
    property  RAlias:string read FrAlias write FrAlias;
    property  RootPath:string read FRootpath write FRootPath;
    property  CurrentPath:string read FCurrentPath write FCurrentPath;
    property  ValidPath:string read FValidPath write FValidPath;

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

function TfrmFiles.ListAndFill:boolean;
var
  m:string;
  mTmp:TStrings;
  mStream2:TStringStream;
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
  mStream2:=TStringStream.Create(m,TEncoding.Default);
//  ShowMessage(mStream2.DataString);
//  mStream:=TMemoryStream.Create;
//  mTmp.SaveToStream(mStream);
  mStream2.Seek(0,soBeginning);
  try
    mData := GetJSon(mStream2);
  Except
    mData := nil;
  end;
  mStream2.Free;
  mTmp.Free;
  if mData<>nil then
  begin
    mArray := TJsonArray(mData);
    ListFiles.Items.BeginUpdate;
    ListFiles.Items.Clear;
    if CurrentPath<>'/' then
    begin
      with ListFiles.Items.Add do
      begin
        Caption := '..';
        SubItems.Add('(返回上级目录)');
        SubItems.Add('');
        SubItems.Add('');
        SubItems.Add('True');
      end;
    end;
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
        SubItems.Add(LowerCase(mItem.FindPath('IsDir').AsString));
      end;
    end;
    ListFiles.Items.EndUpdate;
    Result:=True;
  end
  else
  begin
    MessageDlg('路径不存在。',mtError,[mbOK],0);
    Result:=False;
  end;
end;

procedure TfrmFiles.AddPath;
begin
  ComboPath.Text:=CurrentPath;
  if ComboPath.Items.IndexOf(CurrentPath)<0 then
    ComboPath.Items.Add(CurrentPath);
end;

procedure TfrmFiles.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TfrmFiles.ComboPathKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if Trim(ComboPath.Text)<>'' then
    begin
      CurrentPath := Trim(ComboPath.Text);
      if ListAndFill then
      begin
        AddPath;
        ValidPath := CurrentPath;
      end
      else
      begin
        CurrentPath := ValidPath;
        ComboPath.Text := ValidPath;
      end;
    end;
  end;
end;

procedure TfrmFiles.ComboPathSelect(Sender: TObject);
begin
  if ComboPath.ItemIndex>=0 then
  begin
    CurrentPath := Trim(ComboPath.Text);
    ListAndFill;
  end;
end;

procedure TfrmFiles.FormShow(Sender: TObject);
begin
  if Trim(RootPath)='' then RootPath:='/';
  CurrentPath:=RootPath;
  ValidPath := CurrentPath;
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

procedure TfrmFiles.ListFilesDblClick(Sender: TObject);
var
  mDirName,mIsDir:string;
  mParentPath:string;
  mChildPath :string;
begin
  //双击
  if Listfiles.Selected<>nil then
  begin
    mDirName := Trim(ListFiles.Selected.Caption);
    mIsDir   := Trim(ListFiles.Selected.SubItems.Strings[3]);
    if mDirName = '..' then
    begin
      //返回上级目录
      mParentPath := ParentDir(ValidPath);
      CurrentPath := mParentPath;
      if ListAndFill then
      begin
        ComboPath.Text := CurrentPath;
        ValidPath := CurrentPath;
      end;
    end
    else
    begin
      if Lowercase(mIsDir)='true' then
      begin
        //进入下级目录
        if ValidPath<>'/' then
          CurrentPath := ValidPath+'/'+mDirName
        else
          CurrentPath := '/'+mDirName;
        //ShowMessage(CurrentPath);
        if ListAndFill then
        begin
          ComboPath.Text := CurrentPath;
          ValidPath := CurrentPath;
          AddPath;
        end;
      end
      else
      begin
        ShowMessage('操作文件');
      end;
    end;
  end;
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

