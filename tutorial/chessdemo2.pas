
program ChessDemo2;

uses
  SysUtils, Classes, Chess;

const
  CFileName = 'fischerandom.fen';
  
var
  i: integer;
  LPos: TPosition;
  
begin
  with TStringList.Create do
  try
    LoadFromFile(CFileName);
    for i := 0 to 959 do
    begin
      LPos := EncodePosition(strings[i], TRUE);
      if Concat(DecodePosition(LPos, TRUE), ' 0 1') <> strings[i] then
        WriteLn('Unexpected result (', i, ')');
    end;
    WriteLn('Done');
  finally
    Free;
  end;
end.
