unit datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection;

type

  { Tdm }

  Tdm = class(TDataModule)
    conn: TZConnection;
  private

  public

  end;

var
  dm: Tdm;

implementation

{$R *.frm}

end.

