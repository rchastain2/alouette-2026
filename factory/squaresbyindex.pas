
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
    Write('$', IntToHex(ToBoard(i)));
    if i < 63 then
      WriteLn(',')
    else
      WriteLn();
  end;
end.
