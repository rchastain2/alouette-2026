
uses
  Board, Constants, Types;

begin
{ Cases pouvant être atteintes par une tour se trouvant en B2. }
  PrintBoard(CTargets[ptRook, B2]);
end.

{
  +   abcdefgh   +

  8   01000000   8
  7   01000000   7
  6   01000000   6
  5   01000000   5
  4   01000000   4
  3   01000000   3
  2   10111111   2
  1   01000000   1

  +   abcdefgh   +
}
