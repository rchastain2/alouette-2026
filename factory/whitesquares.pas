
program WhiteSquares;

uses
{$IFDEF FPC}
  SysUtils,
{$ELSE}
  MissingFunction,
{$ENDIF}
  Board;
  
var
  x, y: integer;
  LBoard: Int64;
  
begin
  LBoard := 0;
  for x := 0 to 7 do
    for y := 0 to 7 do
      if (x + y) mod 2 = 1 then
        SwitchOn(LBoard, ToBoard(ToIndex(x, y)));
  
  Write('$', IntToHex(LBoard));
end.
