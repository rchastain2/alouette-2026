
program SquaresByIndex;

uses
{$IFDEF FPC}
  SysUtils,
{$ELSE}
  MissingFunction,
{$ENDIF}
  Board;

var
  i: integer;

begin
  for i := 0 to 63 do
  begin
    if (i + 1) mod 8 = 1 then
      Write('   ');
    Write(' $', IntToHex(ToBoard(i)));
    if i < 63 then
    begin
      Write(',');
      if (i + 1) mod 8 = 0 then
        WriteLn();
    end;
  end;
end.
