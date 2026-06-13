
program Fact3;

uses
  StrUtils;

function IntToHex(AVal: uint64): string;
const
  CDigits = '0123456789ABCDEF';
var
  LAux: string;
  LRem: uint64;
begin
  LAux := '';
  
  while AVal <> 0 do
  begin
    LRem := AVal mod 16;
    LAux := LAux + Copy(CDigits, LRem, 1);
    AVal := AVal div 16;
  end;
  
  while Length(LAux) < 16 do
    LAux := LAux + '0';
  
  result := ReverseString(LAux);
end;

function ToBoard(const AIdx: integer): uint64;
begin
  result := uint64(1) shl AIdx;
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
