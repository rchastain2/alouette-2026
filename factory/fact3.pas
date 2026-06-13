
program Fact3;
{
uses
  SysUtils;
}
uses
  StrUtils;

function IntToHex(AInt: uint64): string;
const
  CDigits = '0123456789ABCDEF';
var
  LAux: string;
  LRem: uint64;
begin
  LAux := '';
  
  while AInt <> 0 do
  begin
    LRem := AInt mod 16;
    LAux := LAux + Copy(CDigits, LRem, 1);
    AInt := AInt div 16;
  end;
  
  while Length(LAux) < 16 do
    LAux := LAux + '0';
  
  result := ReverseString(LAux);
end;

function ToBoard(const AIdx: integer): uint64;
begin
  result := uint64(1) shl AIdx;
end;

var
  i: integer;

begin
  for i := 0 to 63 do
  begin
    Write('$', IntToHex(ToBoard(i){, 16}));
   {Write('%'); for j := 63 downto 0 do if j = i then Write(1) else Write(0);}
    if i < 63 then
      WriteLn(',')
    else
      WriteLn();
  end;
end.
