unit datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, gogopluginss;

type

  { Tdm }

  Tdm = class(TDataModule)
    conn: TZConnection;
  private

  public
    Plugins:TGoGoPlugins;
  end;

var
  dm: Tdm;

implementation

{$R *.frm}

end.

