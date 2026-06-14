
program Columns;

uses
  SysUtils, Board;

var
  x, y: integer;
  LBoard: Int64;
  
begin  
  for x := 0 to 7 do
  begin
    LBoard := 0;
    for y := 0 to 7 do
      SetBitTo1(LBoard, CCoordToSquare[x, y]);
    Write(' $', IntToHex(LBoard));
    if x < 7 then
      WriteLn(',')
    else
      WriteLn();
  end;
end.
