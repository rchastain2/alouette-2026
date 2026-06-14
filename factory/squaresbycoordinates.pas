
program SquaresByCoordinates;

uses
  SysUtils;

function ToBoard(const AIdx: integer): int64;
begin
  result := int64(1) shl AIdx;
end;

function ToIndex(const ACol, ARow: integer): integer;
begin
  result := 8 * ARow + ACol;
end;

var
  x, y: integer;

begin
  for x := 0 to 7 do
  begin
    Write('(');
    for y := 0 to 7 do
    begin
      Write('$', IntToHex(ToBoard(ToIndex(x, y))));
      if y < 7 then
        Write(', ');
    end;
    if x < 7 then
      WriteLn('),')
    else
      WriteLn(')');
  end;
end.
