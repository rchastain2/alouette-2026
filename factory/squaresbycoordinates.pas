
program SquaresByCoordinates;

uses
{$IFDEF FPC}
  SysUtils,
{$ELSE}
  MissingFunction,
{$ENDIF}
  Board;

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
