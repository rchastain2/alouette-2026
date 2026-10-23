{
  Blaise compiler bug: default parameter values are ignored in nested procedures.

  Compiler: Blaise v0.16.0-SNAPSHOT (v0.15.0-5-gb45216c8), linux-x86_64.

  A procedure nested in another procedure declares a parameter with a default
  value. Calling it without that parameter is rejected, as if the parameter
  had no default value. The same declaration works for a procedure which is
  not nested.

  Build and run:
    blaise --source bug4.pas --output bug4
    ./bug4

  Expected output:
    0

  Actual output (compilation fails):
    Semantic error: Nested procedure 'Inner' expects 1 argument(s), got 0 at line 34 col 3 in Bug4
}

program Bug4;

procedure Outer;

{ The parameter has a default value. }
  procedure Inner(const A: integer = 0);
  begin
    WriteLn(A);
  end;

begin
{ The call without argument is rejected. }
  Inner();
end;

begin
  Outer();
end.
