{
  Blaise compiler bug: wrong scope order between interface and implementation uses clauses.

  Compiler: Blaise v0.16.0-SNAPSHOT (v0.15.0-5-gb45216c8), linux-x86_64.

  UnitA and UnitB both declare a function F. UnitC uses UnitA in its interface
  section and UnitB in its implementation section. In Delphi and Free Pascal,
  the units of the implementation uses clause are searched first, so F
  refers to UnitB.F. Blaise resolves F to UnitA.F, without error or warning.

  Within a single uses clause, the order is correct: with "uses UnitA, UnitB;",
  F refers to UnitB.F.

  Build and run (from this directory):
    blaise --source bug6.pas --output bug6 --unit-path .
    ./bug6

  Expected output (as with Free Pascal):
    2

  Actual output:
    1
}

program Bug6;

uses
  UnitC;

begin
  WriteLn(G());
end.
