{
  Unit used by bug6.pas (see that file for the description of the bug).
}

unit UnitC;

interface

uses
  UnitA;

function G: integer;

implementation

{ UnitB, used in the implementation section, should hide UnitA.F. }
uses
  UnitB;

function G: integer;
begin
  result := F();
end;

end.
