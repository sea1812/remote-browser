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
    EditName: TEdit;
    EditAlias: TEdit;
    EditComment: TEdit;
    EditUrl: TEdit;
    EditUsername: TEdit;
    EditPwd: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
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
    function  RnameExists(AValue:string):boolean;//检查rname是否存在
    procedure DoInsert(AName,AUrl,AUser,APwd,AComment:string);//插入记录
    function  BuildParams(AUrl,AUser,APwd:string):string;//组合成设置JSON字符串
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
  EditName.SetFocus;
end;

procedure TfrmEdit.RxSpeedButton1Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

function TfrmEdit.RnameExists(AValue: string): boolean;
begin
  Result:=True;
  with Qry do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select count(*) as aa from remotes2 where rname=:rname');
    Params.ParamByName('rname').AsString:=Trim(AValue);
    Open;
    First;
    if not Eof then
    begin
      Result := FieldByName('aa').AsInteger>0;
    end;
  end;
end;

procedure TfrmEdit.DoInsert(AName, AUrl, AUser, APwd, AComment: string);
var
  mId:integer;
  mAlias:string;
begin
  with Qry do
  begin
    Close;
    Sql.Clear;
    //先插入
    Sql.Add('insert into remotes2 (rname,rtype,ralias,rparams,rletter,rcomment) values (:rname,:rtype,:ralias,:rparams,:rletter,:rcomment)');
    Params.ParamByName('rname').AsString:=Trim(AName);
    Params.ParamByName('rtype').AsString:=Trim('webdav');
    Params.ParamByName('ralias').AsString:='none';
    Params.ParamByName('rparams').AsString:=BuildParams(AUrl,AUser,APwd);//组合成JSON字符串
    Params.ParamByName('rletter').AsString:='';
    Params.ParamByName('rcomment').AsString:=AComment;
    ExecSQL;
    //获取插入数据的ID生成ralias字符串
    Close;
    Sql.Clear;
    Sql.Add('select max(id) as aa from remotes2');
    Open;
    First;
    if not Eof then
    begin
      mID := FieldByName('aa').AsInteger;
      mAlias := 'webdav_'+inttostr(mID);
    end;
    //更新回去
    if Trim(mAlias)<>'' then
    begin
      Close;
      Sql.Clear;
      Sql.Add('update remotes2 set ralias=:ralias where id=:id');
      Params.ParamByName('id').AsInteger:=mID;
      Params.ParamByName('ralias').AsString:=mAlias;
      ExecSQL;
    end;
  end;
end;

function TfrmEdit.BuildParams(AUrl, AUser, APwd: string): string;
begin
  Result := '{"url":"'+AUrl+'","user":"'+AUser+'","pwd":"'+APwd+'"}';
end;

procedure TfrmEdit.Button1Click(Sender: TObject);
begin
  //检查输入是否完整
  if Trim(EditName.Text)='' then
  begin
    MessageDlg('请输入标识名称。',mtWarning,[mbOK],0);
    EditName.SetFocus;
    Exit;
  end;
  if Trim(EditUrl.Text)='' then
  begin
    MessageDlg('请输入网址路径。',mtWarning,[mbOK],0);
    EditUrl.SetFocus;
    Exit;
  end;
  if Trim(EditUsername.Text)='' then
  begin
    MessageDlg('请输入登录账号。',mtWarning,[mbOK],0);
    EditUsername.SetFocus;
    Exit;
  end;
  if Trim(EditPwd.Text)='' then
  begin
    MessageDlg('请输入登录密码。',mtWarning,[mbOK],0);
    EditPwd.SetFocus;
    Exit;
  end;
  //检查输入的标识名称是否存在
  if RnameExists(EditName.Text)=True then
  begin
    MessageDlg('标识名称已存在，请修改。',mtWarning,[mbOK],0);
    EditName.SetFocus;
    Exit;
  end;
  if Self.ID=0 then
  begin
    //插入
    DoInsert(Trim(EditName.Text),Trim(EditUrl.Text),Trim(EditUsername.Text),Trim(EditPwd.Text),Trim(EditComment.Text));
    ModalResult:=mrOK;
  end
  else
  begin
    //更新

  end;

end;

begin
   Application.Initialize;
end.

