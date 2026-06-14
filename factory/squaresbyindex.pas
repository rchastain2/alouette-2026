
program SquaresByIndex;

uses
  SysUtils;

function ToBoard(const AIdx: integer): int64;
begin
  result := int64(1) shl AIdx;
end;

var
  i: integer;

begin
  for i := 0 to 63 do
  begin
    Write('$', IntToHex(ToBoard(i)));
    if i < 63 then
      WriteLn(',')
    else
      WriteLn();
  end;
end.
