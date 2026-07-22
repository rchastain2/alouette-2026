
program BoardDemoPaths;

uses
  Board, Constants, ChessTypes;

begin
{ Cases à traverser pour aller d'une case à une autre. }
  PrintBoard(CPaths[A1, H8]);
  PrintBoard(CPaths[A8, H1]);
  PrintBoard(CPaths[A1, A8]);
  PrintBoard(CPaths[A8, A1]);
  PrintBoard(CPaths[A1, H1]);
  PrintBoard(CPaths[H1, A1]);
end.

{
  +   abcdefgh   +

  8   00000000   8
  7   00000010   7
  6   00000100   6
  5   00001000   5
  4   00010000   4
  3   00100000   3
  2   01000000   2
  1   00000000   1

  +   abcdefgh   +
  +   abcdefgh   +

  8   00000000   8
  7   01000000   7
  6   00100000   6
  5   00010000   5
  4   00001000   4
  3   00000100   3
  2   00000010   2
  1   00000000   1

  +   abcdefgh   +
  +   abcdefgh   +

  8   00000000   8
  7   10000000   7
  6   10000000   6
  5   10000000   5
  4   10000000   4
  3   10000000   3
  2   10000000   2
  1   00000000   1

  +   abcdefgh   +
  +   abcdefgh   +

  8   00000000   8
  7   10000000   7
  6   10000000   6
  5   10000000   5
  4   10000000   4
  3   10000000   3
  2   10000000   2
  1   00000000   1

  +   abcdefgh   +
  +   abcdefgh   +

  8   00000000   8
  7   00000000   7
  6   00000000   6
  5   00000000   5
  4   00000000   4
  3   00000000   3
  2   00000000   2
  1   01111110   1

  +   abcdefgh   +
  +   abcdefgh   +

  8   00000000   8
  7   00000000   7
  6   00000000   6
  5   00000000   5
  4   00000000   4
  3   00000000   3
  2   00000000   2
  1   01111110   1

  +   abcdefgh   +
}
