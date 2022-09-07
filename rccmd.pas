unit rccmd;

{$mode objfpc}{$H+}

interface

uses
  Interfaces,Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, ComCtrls, Buttons,  windows,
  Process,  fpjson, jsonparser,  LCLIntf;

procedure KillProcessByPID(APID: integer);
procedure ExecuteCommand(ACommand: string; AParams: TStrings;AOutput: TStrings; AutoFinish:boolean=False);
function  ExecuteCommandSpec(ACommand: string; AParams: TStrings):integer;
procedure DoConfigCreateRemote(ARemote, AType: string);
procedure DoConfigUpdate(ARemote, AKey, AValue: string);
procedure DoConfigPassword(ARemote, APassword: string);
procedure DoConfigDeleteRemote(ARemote: string);
function  DoMount(ARemote, ADriveLetter, AVolumeLabel,ACacheDir: string):integer;
function  DoListRemotes: string;
procedure ParseRemoteNames(AIn: string; AOut: TStrings);
function  RemoteExists(ARemote:string):boolean;
function  ParamsToJson(AParams:string):TJSONData;

implementation

function  ParamsToJson(AParams:string):TJSONData;
var
  mTmp:TStrings;
  mStream:TMemoryStream;
begin
  mTmp:=TStringList.Create;
  mTmp.Text:=AParams;
  mStream:=TMemoryStream.Create;
  mTmp.SaveToStream(mStream);
  mStream.Seek(0,soBeginning);
  try
    Result := GetJSon(mStream);
  Except
    Result := nil;
  end;
  mStream.Free;
  mTmp.Free;
end;

function RemoteExists(ARemote: string): boolean;
var
  m:string;
  mTmp:TStrings;
begin
  Result:=False;
  m := DoListRemotes;
  mTmp:=TStringList.Create;
  ParseRemoteNames(m,mTmp);
  if mTmp.IndexOf(Trim(ARemote))>=0 then
     Result := True;
  mTmp.Free;
end;

procedure ParseRemoteNames(AIn: string; AOut: TStrings);
var
  mTmp:TStrings;
  mLine:string;
  i:integer;
begin
  if Pos('notice:',LowerCase(AIn))<=0 then
  begin
    AOut.Clear;
    mTmp := TStringList.Create;
    mTmp.Text:=AIn;
    //循环去除冒号
    for i:=0 to mTmp.Count-1 do
    begin
      mLine:=Trim(mTmp.Strings[i]);
      if Trim(mLine)<>'' then
      begin
        //去除冒号
        if Pos(':',mLine)>0 then
        begin
          mLine:=StringReplace(mLine,':','',[rfReplaceAll]);
          AOut.Add(mLine);
        end;
      end;
    end;
    mTmp.Free;
  end
  else
  begin
    AOut.Text:='';
  end;
end;

function DoListRemotes: string;
var
  mParams,mOutput:TStrings;
begin
  //执行rc listremotes
  mOutput:=TStringList.Create;
  mParams:=TStringList.Create;
  mParams.Add('/c');
  mParams.Add('.\rc listremotes');

  ExecuteCommand('c:\windows\system32\cmd.exe',mParams,mOutput,False);
  Result := Trim(mOutput.Text);
  mParams.Free;
  mOutput.Free;
end;

function DoMount(ARemote, ADriveLetter, AVolumeLabel,
  ACacheDir: string):integer;
var
  mParams:TStrings;
  mPID:integer;
begin
  //执行rc config create
  mParams:=TStringList.Create;
  mParams.Add('/c');
  mParams.Add('.\rc mount '+ARemote+': '+ADriveLetter+': --cache-dir '+ACacheDir+' --vfs-cache-mode writes --volname '+AVolumeLabel);
  mPID:=ExecuteCommandSpec('c:\windows\system32\cmd.exe', mParams);
  mParams.Free;
  Result:=mPID;
end;

procedure DoConfigDeleteRemote(ARemote: string);
var
  mParams,mOutput:TStrings;
begin
  //执行rc config delete
  mOutput:=TStringList.Create;
  mParams:=TStringList.Create;
  mParams.Add('/c');
  mParams.Add('.\rc config delete '+ARemote);

  ExecuteCommand('c:\windows\system32\cmd.exe',mParams,mOutput,False);
  mParams.Free;
  mOutput.Free;
end;

procedure DoConfigPassword(ARemote, APassword: string);
var
  mParams,mOutput:TStrings;
begin
  //执行rc config create
  mOutput:=TStringList.Create;
  mParams:=TStringList.Create;
  mParams.Add('/c');
  mParams.Add('.\rc config password '+ARemote+' pass '+APassword);

  ExecuteCommand('c:\windows\system32\cmd.exe',mParams,mOutput,False);
  mParams.Free;
  mOutput.Free;
end;

procedure DoConfigUpdate(ARemote, AKey, AValue: string);
var
  mParams,mOutput:TStrings;
begin
  //执行rc config update
  mOutput:=TStringList.Create;
  mParams:=TStringList.Create;
  mParams.Add('/c');
  mParams.Add('.\rc config update '+ARemote+' '+AKey+' '+AValue);

  ExecuteCommand('c:\windows\system32\cmd.exe',mParams,mOutput,False);
  mParams.Free;
  mOutput.Free;
end;

procedure DoConfigCreateRemote(ARemote, AType: string);
var
  mParams,mOutput:TStrings;
begin
  //执行rc config create
  mOutput:=TStringList.Create;
  mParams:=TStringList.Create;
  mParams.Add('/c');
  mParams.Add('.\rc config create '+ARemote+' '+AType);

  ExecuteCommand('c:\windows\system32\cmd.exe',mParams,mOutput,False);
  mParams.Free;
  mOutput.Free;
end;

procedure ExecuteCommand(ACommand: string; AParams: TStrings;
  AOutput: TStrings; AutoFinish:boolean=False);
const
  BUF_SIZE = 2048;
var
  mProcess     : TProcess;
  mOutputStream : TStringStream;
  mBytesRead    : longint;
  mBuffer       : array[1..BUF_SIZE] of byte;
  i:integer;
begin
  mProcess := TProcess.Create(nil);
  mProcess.Executable := ACommand;
  for i:=0 to AParams.Count-1 do
  begin
    if Trim(AParams.Strings[i])<>'' then
      mProcess.Parameters.Add(AParams.Strings[i]);
  end;
  mProcess.Options := [poUsePipes,poNoConsole];
  mProcess.Execute;

  if AutoFinish then
  begin
    Sleep(3000);
    mProcess.Terminate(0);
    mProcess.Free;
    AOutput.Text:='';
    Exit;
  end;

  mOutputStream := TStringStream.Create('',TEncoding.Default);

  repeat
    mBytesRead := mProcess.Output.Read(mBuffer, BUF_SIZE);
    mOutputStream.Write(mBuffer, mBytesRead)
  until mBytesRead = 0;
  mProcess.Free;

  mOutputStream.Seek(0,soBeginning);
  AOutput.Text:=mOutputStream.DataString;
  mOutputStream.Free;
end;

function ExecuteCommandSpec(ACommand: string; AParams: TStrings):integer;
var
  mProcess     : TProcess;
  i:integer;
begin
  mProcess := TProcess.Create(nil);
  mProcess.Executable := ACommand;
  for i:=0 to AParams.Count-1 do
  begin
    if Trim(AParams.Strings[i])<>'' then
      mProcess.Parameters.Add(AParams.Strings[i]);
  end;
  mProcess.Options := [poNoConsole];
  mProcess.Execute;
  Result:=mProcess.ProcessID;
end;

procedure KillProcessByPID(APID: integer);
var
  mParams,mOutput:TStrings;
begin
  if APID>0 then
  begin
    mOutput:=TStringList.Create;
    mParams:=TStringList.Create;
    mParams.Add('/c');
    mParams.Add('taskkill /F /T /PID '+inttostr(APID));

    ExecuteCommand('c:\windows\system32\cmd.exe',mParams,mOutput,True);
    mParams.Free;
    mOutput.Free;
  end;
end;


end.

