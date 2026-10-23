{
  Unit used by bug2.pas (see that file for the description of the bug).

  An array type indexed by boolean, declared in the interface section,
  cannot be read back from the cached unit1.o.
}

unit Unit1;

interface

type
{ With array[0..1] of integer, the bug does not occur. }
  TArr = array[boolean] of integer;

implementation

end.
