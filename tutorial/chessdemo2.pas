program ChessDemo2;

uses
  SysUtils, Classes, Chess;

const
  CFileName = 'fischerandom.fen';
  
var
  i: integer;
  LPos: TPosition;
  LList: TStringList;
  
begin
  LList := TStringList.Create;
  try
    LList.LoadFromFile(CFileName);
    for i := 0 to 959 do
    begin
      LPos := EncodePosition(LList[i], TRUE);
      if DecodePosition(LPos, TRUE) + ' 0 1' <> LList[i] then
        WriteLn('Unexpected result (', i, ')');
    end;
    WriteLn('Done');
  finally
    LList.Free();
  end;
end.
