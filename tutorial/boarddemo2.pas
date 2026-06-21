
program BoardDemoWhiteSquares;

uses
  Board, Constants;

begin
  PrintBoard(CWhiteSquares);
  PrintBoard(not CWhiteSquares);
end.

{
  +   abcdefgh   +

  8   10101010   8
  7   01010101   7
  6   10101010   6
  5   01010101   5
  4   10101010   4
  3   01010101   3
  2   10101010   2
  1   01010101   1

  +   abcdefgh   +
  +   abcdefgh   +

  8   01010101   8
  7   10101010   7
  6   01010101   6
  5   10101010   5
  4   01010101   4
  3   10101010   3
  2   01010101   2
  1   10101010   1

  +   abcdefgh   +
}
