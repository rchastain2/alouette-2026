
unit Constants;

interface

uses
  ChessTypes;

const
  CWhiteSquares: Int64 = {$I whitesquares.inc};
  
  CColumns: array[0..7] of Int64 = (
{$I columns.inc}
  );
  
  CSquareNames: array[A1..H8] of string = (
{$I squarenamesarray.inc}
  );
  
  CIndexToSquare: array[A1..H8] of Int64 = (
{$I squaresbyindex.inc}
  );
  
  CCoordToSquare: array[0..7, 0..7] of Int64 = (
{$I squaresbycoordinates.inc}
  );
  
  CTargets: array[ptWhitePawn..ptKing, A1..H8] of Int64 = (
{$I targets.inc}
  );
  
  CPaths: array[A1..H8, A1..H8] of Int64 = (
{$I paths.inc}
  );

implementation

end.
