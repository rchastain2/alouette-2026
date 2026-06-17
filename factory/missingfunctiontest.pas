
uses
  SysUtils,
  MissingFunction;

{$ASSERTIONS ON}

procedure Compare(const n: Int64);
var
  s1, s2: string;
begin
  s1 := SysUtils.IntToHex(n);
  s2 := MissingFunction.IntToHex(n);
  Assert(s2 = s1);
end;

var
  n: Int64;
  i: Integer;

begin
  Randomize;
  for i := 1 to 1000 do
  begin
    n := Random(High(Int64));
    Compare(n);
  end;
end.
