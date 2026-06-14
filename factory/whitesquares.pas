
program WhiteSquares;

uses
  SysUtils, Board;
  
var
  x, y: integer;
  LBoard: int64;
  
begin
  LBoard := 0;
  for x := 0 to 7 do
    for y := 0 to 7 do
      if (x + y) mod 2 = 1 then
        SetBitTo1(LBoard, CCoordToSquare[x, y]);
  
  WriteLn(' $', IntToHex(LBoard));
end.
