
program Paths;

uses
  SysUtils, Board;

function GetPath(const AFr, ATo: integer): int64;
var
  x1, y1, x2, y2, dx, dy: integer;
begin
  result := 0;
  x1 := AFr mod 8;
  y1 := AFr div 8;
  x2 := ATo mod 8;
  y2 := ATo div 8;
  dx := x2 - x1;
  dy := y2 - y1;
  if ((dx <> 0) or (dy <> 0))
  and (((dx = 0) or (dy = 0)) or (Abs(dx) = Abs(dy))) then
  begin
    if dx <> 0 then dx := dx div Abs(dx);
    if dy <> 0 then dy := dy div Abs(dy);
    repeat
      Inc(x1, dx);
      Inc(y1, dy);
      if (x1 <> x2)
      or (y1 <> y2) then
        result := result or CCoordToSquare[x1, y1];
    until (x1 = x2) and (y1 = y2);
  end;
end;

var
  LFrom, LTo: integer;
  LBoard: int64;
  
begin
  for LFrom := 0 to 63 do
  begin
    WriteLn('(');
    for LTo := 0 to 63 do
    begin
      LBoard := GetPath(LFrom, LTo);
      Write(' $', IntToHex(LBoard));
      if LTo < 63 then
        Write(',');
      if Succ(LTo) mod 4 = 0 then
        WriteLn();
    end;
    Write(')');
    if LFrom < 63 then
      WriteLn(',')
    else
      WriteLn();
  end;
end.
