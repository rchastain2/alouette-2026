
unit Board;

interface

const
  A8 = 56; B8 = 57; C8 = 58; D8 = 59; E8 = 60; F8 = 61; G8 = 62; H8 = 63;
  A7 = 48; B7 = 49; C7 = 50; D7 = 51; E7 = 52; F7 = 53; G7 = 54; H7 = 55;
  A6 = 40; B6 = 41; C6 = 42; D6 = 43; E6 = 44; F6 = 45; G6 = 46; H6 = 47;
  A5 = 32; B5 = 33; C5 = 34; D5 = 35; E5 = 36; F5 = 37; G5 = 38; H5 = 39;
  A4 = 24; B4 = 25; C4 = 26; D4 = 27; E4 = 28; F4 = 29; G4 = 30; H4 = 31;
  A3 = 16; B3 = 17; C3 = 18; D3 = 19; E3 = 20; F3 = 21; G3 = 22; H3 = 23;
  A2 = 08; B2 = 09; C2 = 10; D2 = 11; E2 = 12; F2 = 13; G2 = 14; H2 = 15;
  A1 = 00; B1 = 01; C1 = 02; D1 = 03; E1 = 04; F1 = 05; G1 = 06; H1 = 07;

type
  {** Type de pièce, incluant la valeur néant. }
  TPieceTypeExtended = (ptNil, ptWhitePawn, ptBlackPawn, ptRook, ptKnight, ptBishop, ptQueen, ptKing);
  {** Type de pièce. }
  TPieceType = ptWhitePawn..ptKing;
  {** Type de coup. }
  TMoveType = (mtCapture, mtCastling, mtEnPassant, mtPromotion, mtPromotionKnight, mtPromotionBishop, mtPromotionRook);
  {** }
  TMoveTypeSet = set of TMoveType;

const
  CSquareNames: array[A1..H8] of string        = ({$I squarenamesarray.inc});
  CIndexToSquare: array[A1..H8] of Int64       = ({$I squaresbyindex.inc});
  CCoordToSquare: array[0..7, 0..7] of Int64   = ({$I squaresbycoordinates.inc});
  CPaths: array[A1..H8, A1..H8] of Int64       = ({$I paths.inc});
  CColumns: array[0..7] of Int64               = ({$I columns.inc});
  CWhiteSquares: Int64                         = ({$I whitesquares.inc});
  CTargets: array[TPieceType, A1..H8] of Int64 = ({$I targets.inc});

{** Pour savoir si une case est allumée dans un damier. }
function Is1(const ABrd, ASqr: Int64): boolean;
{** Allume une case dans un damier. }
procedure SetBitTo1(var ABrd: Int64; const ASqr: Int64);
{** Éteint une case. }
procedure SetBitTo0(var ABrd: Int64; const ASqr: Int64);

function BoardToPrettyStr(const ABrd: Int64): string;
procedure PrintBoard(const ABrd: Int64);

implementation

uses
  SysUtils;

function Is1(const ABrd, ASqr: Int64): boolean;
begin
  result := (ABrd and ASqr) = ASqr;
end;

procedure SetBitTo1(var ABrd: Int64; const ASqr: Int64);
begin
  ABrd := ABrd or ASqr;
end;

procedure SetBitTo0(var ABrd: Int64; const ASqr: Int64);
begin
  ABrd := ABrd and not ASqr;
end;

function BoardToPrettyStr(const ABrd: Int64): string;
var
  x, y: integer;
begin
  result := '+   abcdefgh   +' + LineEnding + LineEnding;
  for y := 7 downto 0 do
  begin
    result := result + IntToStr(y + 1) + '   ';
    for x := 0 to 7 do
      result := result + IntToStr(Ord(Is1(ABrd, CCoordToSquare[x, y])));
    result := result + '   ' + IntToStr(y + 1) + LineEnding;
  end;
  result := result + LineEnding + '+   abcdefgh   +';
end;

procedure PrintBoard(const ABrd: Int64);
begin
  WriteLn(BoardToPrettyStr(ABrd));
end;

end.
