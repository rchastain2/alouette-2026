{
  Blaise compiler bug: set literal passed as argument to a nested procedure.

  Compiler: Blaise v0.16.0-SNAPSHOT (v0.15.0-5-gb45216c8), linux-x86_64.

  Passing a set literal to a nested procedure makes code generation fail.
  The same call works for a procedure which is not nested, and passing a
  typed constant of the set type to the nested procedure works.

  Build and run:
    blaise --source bug5.pas --output bug5
    ./bug5

  Expected output:
    11
    11

  Actual output (compilation fails):
    Code generation error: native backend: unsupported expression form TArrayLiteralExpr at line 44 col 9 in Bug5
}

program Bug5;

type
  TMoveType = (mtCapture, mtCastling, mtEnPassant, mtPromotion);
  TMoveTypeSet = set of TMoveType;

procedure Top(const mt: TMoveTypeSet);
begin
  WriteLn(Ord(mtCapture in mt), Ord(mtPromotion in mt));
end;

procedure Outer;

  procedure Inner(const mt: TMoveTypeSet);
  begin
    WriteLn(Ord(mtCapture in mt), Ord(mtPromotion in mt));
  end;

begin
{ This call works. }
  Top([mtCapture, mtPromotion]);
{ This call makes code generation fail. }
  Inner([mtCapture, mtPromotion]);
end;

begin
  Outer();
end.
