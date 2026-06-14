
program SquareNames;

uses
  SysUtils;

function SquareName(const x, y: integer): string;
begin
  result := Chr(x + Ord('A')) + Chr(y + Ord('1'));
end;

var
  x, y: integer;

begin
  for y := 7 downto 0 do
  begin
    Write(' ');
    for x := 0 to 7 do
      Write(Format(' %s = %0.2d;', [SquareName(x, y), 8 * y + x]));
    WriteLn();
  end;
end.
