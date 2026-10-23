{
  Blaise compiler bug: import error when the unit object file is reused.

  Compiler: Blaise v0.16.0-SNAPSHOT (v0.15.0-5-gb45216c8), linux-x86_64.

  Unit1 declares an array type indexed by boolean. The first compilation
  succeeds and writes unit1.o. The second compilation, which reads the
  interface of Unit1 from unit1.o, fails. The option --no-incremental does
  not avoid the error; deleting unit1.o does.

  Build and run (from this directory):
    blaise --source bug2.pas --output bug2 --unit-path .
    ./bug2
    blaise --source bug2.pas --output bug2 --unit-path .

  Expected: both compilations succeed, and the program prints 7.

  Actual: the first compilation succeeds and the program prints 7, but the
  second compilation fails with:
    Compiler error [EImportError]: Type alias TArr = array[@boolean] of integer: base not found
}

program Bug2;

uses
  Unit1;

var
  r: TArr;

begin
  r[FALSE] := 7;
  WriteLn(r[FALSE]);
end.
