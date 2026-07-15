
program SquareNamesArray;

function SquareName(const i: integer): string;
begin
  result := Chr(i mod 8 + Ord('a')) + Chr(i div 8 + Ord('1'));
end;

var
  i: integer;

begin
  for i := 0 to 63 do
  begin
    if i mod 8 = 0 then
      Write('    ')
    else
      Write(' ');
    Write('''', SquareName(i), '''');
    if i < 63 then
    begin
      Write(',');
      if i mod 8 = 7 then
        WriteLn();
    end;
  end;
end.
