
program Paths;

uses
{$IFDEF FPC}
  SysUtils,
{$ELSE}
  MissingFunction,
{$ENDIF}
  Board;

var
  LFrom, LTo: integer;
  LBoard: int64;
  
begin
  for LFrom := 0 to 63 do
  begin
    WriteLn('    (');
    for LTo := 0 to 63 do
    begin
      LBoard := GetPath(LFrom, LTo);
      if (LTo + 1) mod 8 = 1 then
        Write('     ');
      Write(' $', IntToHex(LBoard));
      if LTo < 63 then
        Write(',');
      if (LTo + 1) mod 8 = 0 then
        WriteLn();
    end;
    Write('    )');
    if LFrom < 63 then
      WriteLn(',');
  end;
end.
