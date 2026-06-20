
program BoardDemoColumns;

uses
  Board, Constants;

var
  LBrd: Int64;

begin
  LBrd := CColumns[4];
  PrintBoard(LBrd);
end.

{
  +   abcdefgh   +

  8   00001000   8
  7   00001000   7
  6   00001000   6
  5   00001000   5
  4   00001000   4
  3   00001000   3
  2   00001000   2
  1   00001000   1

  +   abcdefgh   +
}
