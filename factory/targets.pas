
program Targets;

uses
{$IFDEF FPC}
  SysUtils,
{$ELSE}
  MissingFunction,
{$ENDIF}
  Board;
  
var
  x, y, i: integer;
  LType: TPieceType;
  LBoard: int64;
  
begin
  for LType := Low(TPieceType) to High(TPieceType) do
  begin
    WriteLn('  (');
    for y := 0 to 7 do
      for x := 0 to 7 do
      begin
        i := ToIndex(x, y);
        LBoard := GetTargets(LType, i);
        if (x = 0) or (x = 4) then
          Write('   ');
        Write(' $', IntToHex(LBoard));
        if i < 63 then
          Write(',');
        if (x = 7) or (x = 3) then
          WriteLn();
      end;
    Write('  )');
    if LType < ptKing then
      WriteLn(',')
    else
     WriteLn();
  end;
end. 
