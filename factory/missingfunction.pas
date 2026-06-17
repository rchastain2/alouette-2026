
unit MissingFunction;

interface

function IntToHex(const AValue: Int64): string;

implementation

uses
  StrUtils;

function IntToHex(const AValue: Int64): string;
var
  LValue, LRem: UInt64;
begin
  result := '';
  LValue := UInt64(AValue);
  while LValue <> 0 do
  begin
    LRem := LValue mod 16;
    result := result + Copy('0123456789ABCDEF', LRem{$IFDEF FPC} + 1{$ENDIF}, 1);
    LValue := LValue div 16;
  end;
  result := ReverseString(result);
  while Length(result) < 16 do
    result := '0' + result;
end;

end.
