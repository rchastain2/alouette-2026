{
  Blaise compiler bug: assignment to result in a nested procedure is lost.

  Compiler: Blaise v0.16.0-SNAPSHOT (v0.15.0-5-gb45216c8), linux-x86_64.

  A procedure nested in a function assigns the result of the enclosing
  function. The program compiles without error or warning, but the
  assignment has no effect on the value returned by the function.

  Assigning a local variable of the enclosing function from the nested
  procedure works as expected.

  Build and run:
    blaise --source bug3.pas --output bug3
    ./bug3

  Expected output:
    7

  Actual output:
    1
}

program Bug3;

function F: integer;

{ Assigns the result of the enclosing function. }
  procedure Inner;
  begin
    result := 7;
  end;

begin
  result := 1;
  Inner();
end;

begin
  WriteLn(F());
end.
