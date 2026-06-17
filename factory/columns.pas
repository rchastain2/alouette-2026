
program Columns;

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
  for x := 0 to 7 do
  begin
    LBoard := 0;
    for y := 0 to 7 do
      SetBitTo1(LBoard, ToBoard(ToIndex(x, y)){CCoordToSquare[x, y]});
    Write(' $', IntToHex(LBoard));
    if x < 7 then
      WriteLn(',')
    else
      WriteLn();
  end;
end.
