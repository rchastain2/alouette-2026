
program Targets;

uses
{$IFDEF FPC}
  SysUtils,
{$ELSE}
  MissingFunction,
{$ENDIF}
  Board;
  
var
  x, y: integer;
  LType: TPieceType;
  LBoard: int64;
  
begin
  for LType := Low(TPieceType) to High(TPieceType) do
  begin
    WriteLn('(');
    for y := 0 to 7 do
      for x := 0 to 7 do
      begin
        LBoard := GetTargets(LType, 8 * y + x);
        Write(' $', IntToHex(LBoard));
        if 8 * y + x < 63 then
          Write(',');
        if (x = 7) or (x = 3) then
          WriteLn();
      end;
    Write(')');
    if LType < ptKing then
      WriteLn(',')
    else
     WriteLn();
  end;
end. 
