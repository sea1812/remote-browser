unit gogopluginss;

{$mode objfpc}{$H+}

interface

uses
  Interfaces,Classes, SysUtils, Forms, Dialogs, windows, ZConnection;

type
  //Plugin

  { TGoGoPluginItem }

  TGoGoPluginItem = class(TComponent)
  public
    LibHandle: TLibHandle;
    LibType:string;
    constructor Create(AOwner:TComponent;ALibname:string);overload;
    destructor  Destroy;override;
    function PlugInfo():PChar;
    function PlugType():PChar;
    function Edit(Handle:HWND;ADBConn:TZConnection):PChar;
  end;

  TPlugInfo  = function (): PChar; stdcall;
  TPlugEdit  = function (APP:TApplication;Handle:HWND;ADBConn:TZConnection):Pchar; stdcall;

  { TGoGoPlugins }

  TGoGoPlugins = class(TComponent)
  private
    FList:TList;
    function GetCount: integer;
  public
    function    Item(AIndex:integer):TGoGoPluginItem;
    function    Add(ALibType:string;ALibName:string):integer;overload;
    function    Add(AItem:TGoGoPluginItem):integer;overload;
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;
    procedure   Clear;
    property Count:integer read GetCount;
  end;

implementation

{ TGoGoPlugins }

function TGoGoPlugins.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TGoGoPlugins.Item(AIndex: integer): TGoGoPluginItem;
begin
  Result:=nil;
  if (AIndex>=0) and (AIndex<=FList.Count) then
  begin
    Result:=TGoGoPluginItem(FList.Items[AIndex]);
  end;
end;

function TGoGoPlugins.Add(ALibType: string; ALibName: string): integer;
var
  mItem:TGoGoPluginItem;
begin
  Result := -1;
  try
    mItem:=TGoGoPluginItem.Create(Self,ALibName);
    mItem.LibType:=ALibType;
    Result:=FList.Add(mItem);
  finally
  end;
end;

function TGoGoPlugins.Add(AItem: TGoGoPluginItem): integer;
begin
  Result:=FList.Add(AItem);
end;

constructor TGoGoPlugins.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList:=TList.Create;
end;

destructor TGoGoPlugins.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TGoGoPlugins.Clear;
var
  i:integer;
begin
  for i:=FList.Count-1 downto 0 do
  begin
    if Assigned(FList.Items[i]) then
    try
      TGoGoPluginItem(FList.Items[i]).Free;
    except
      try
        FreeAndNil(FList.Items[i]^);
      finally
      end;
    end;
  end;
end;

{ TGoGoPluginItem }

constructor TGoGoPluginItem.Create(AOwner: TComponent; ALibname: string);
begin
  inherited Create(AOwner);
  if FileExists(ALibname) then
  begin
    LibHandle := SafeLoadLibrary(ALibName);
    if LibHandle<>0 then
    begin
      //运行PlugInfo方法，获取LibType信息

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

function TGoGoPluginItem.PlugType(): PChar;
var
  mFunc:TPlugInfo;
begin
  Result:='';
  if LibHandle<>0 then
  begin
    mFunc := TPlugInfo(GetProcedureAddress(LibHandle,'PlugType'));
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
      Result:=mFunc(Application,Handle,ADBConn);
    end;
  end;
end;

end.

