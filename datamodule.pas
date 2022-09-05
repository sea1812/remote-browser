unit datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset, gogopluginss;

type

  { Tdm }

  Tdm = class(TDataModule)
    conn: TZConnection;
    InnerQry: TZQuery;
  private

  public
    Plugins:TGoGoPlugins;
  end;

var
  dm: Tdm;

implementation

{$R *.frm}

end.

