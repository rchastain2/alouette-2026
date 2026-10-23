{
  Blaise compiler bug: segmentation fault at runtime.

  Compiler: Blaise v0.16.0-SNAPSHOT (v0.15.0-5-gb45216c8), linux-x86_64.

  When the result of a function returning an array is passed by reference
  (var or out) to a procedure which writes into it, any subsequent write into
  an element of the result causes a segmentation fault.

  The crash does not occur:
  - if the procedure does not write into its parameter;
  - if a local variable is passed instead of the result.

  The index type (boolean, 0..1) and the element type (integer, record) make
  no difference.

  Build and run:
    blaise --source bug1.pas --output bug1
    ./bug1

  Expected output:
    before
    after
    7

  Actual output:
    before
    Segmentation fault (core dumped)
}

program Bug1;

type
  TArr = array[0..1] of integer;

{ Writes into the array passed by reference. }
procedure Clear(var A: TArr);
begin
  A[0] := 0;
end;

function NewArr: TArr;
begin
{ Passing the result by reference... }
  Clear(result);
  WriteLn('before');
{ ...makes this assignment crash. }
  result[0] := 7;
  WriteLn('after');
end;

var
  r: TArr;

begin
  r := NewArr();
  WriteLn(r[0]);
end.
