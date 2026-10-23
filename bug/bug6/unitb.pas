{
  Unit used by bug6.pas (see that file for the description of the bug).
}

unit UnitB;

interface

{ Same name as UnitA.F. }
function F: integer;

implementation

function F: integer;
begin
  result := 2;
end;

end.
