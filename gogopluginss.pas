unit gogopluginss;

{$mode objfpc}{$H+}

interface

uses
  Interfaces,Classes, SysUtils, Dialogs, windows, ZConnection;

type
  //Plugin

  { TGoGoPluginItem }

  TGoGoPluginItem = class(TComponent)
  public
    LibHandle: TLibHandle;
    constructor Create(AOwner:TComponent;ALibname:string);overload;
    destructor  Destroy;override;
    function PlugInfo():PChar;
    function Edit(Handle:HWND;ADBConn:TZConnection):PChar;
  end;

  TPlugInfo  = function (): PChar; stdcall;
  TPlugEdit  = function (Handle:HWND;ADBConn:TZConnection):Pchar; stdcall;

implementation

{ TGoGoPluginItem }

constructor TGoGoPluginItem.Create(AOwner: TComponent; ALibname: string);
begin
  inherited Create(AOwner);
  if FileExists(ALibname) then
  begin
    LibHandle := SafeLoadLibrary(ALibName);
    //ShowMessage('Load '+inttostr(LibHandle));

    if LibHandle=0 then
    begin
      //Notify can't found DLL
    end;
  end;
end;

destructor TGoGoPluginItem.Destroy;
begin
  if LibHandle<>0 then
  begin
    FreeLibrary(LibHandle);
  end;
  inherited Destroy;
end;

function TGoGoPluginItem.PlugInfo(): PChar;
var
  mFunc:TPlugInfo;
begin
  Result:='';
  if LibHandle<>0 then
  begin
    mFunc := TPlugInfo(GetProcedureAddress(LibHandle,'PlugInfo'));
    if Assigned(mFunc) then
    begin
      Result:=mFunc();
    end;
  end;
end;

function TGoGoPluginItem.Edit(Handle:HWND;ADBConn:TZConnection): PChar;
var
  mFunc:TPlugEdit;
begin
  Result:='';
  if LibHandle<>0 then
  begin
    mFunc := TPlugEdit(GetProcedureAddress(LibHandle,'Edit'));
    if Assigned(mFunc) then
    begin
      Result:=mFunc(Handle,ADBConn);
    end;
  end;
end;

end.

