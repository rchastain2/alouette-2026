{**
  @abstract(Roque.)
  Génération du roque.
}

unit Castling;

interface

{ BitAsm dans la partie interface, pour masquer BitCount et BitScanForward de Board : contournement d'un bogue de Blaise (voir bug/bug6). }
uses
  ChessTypes, Board, Chess{$IFDEF BITASM}, BitAsm{$ENDIF};

procedure GenerateCastling(const APos: TPosition; var AList: array of TMove; var ACount: integer);

implementation

uses
  SysUtils, Constants, MoveGen;

procedure GenerateCastling(const APos: TPosition; var AList: array of TMove; var ACount: integer);

  procedure SaveMove(const AFr, ATo: integer);
  begin
    Inc(ACount);
    if ACount <= Length(AList) then
      AList[ACount - 1] := EncodeMove(AFr, ATo, ptKing, [mtCastling]);
  end;

var
{** Toutes les pièces. }
  LPieces,
{** Cases menacées par l'adversaire. }
  LThreats: Int64;
  LRow,
{** Colonne de départ du roi. }
  LKFrCol,
{** Colonne de départ de la tour. }
  LRFrCol: integer;
  LPos: TPosition;

procedure Search(const AKToCol, ARToCol: integer); { Colonnes d'arrivée. }
var
  LKFrIdx, LRFrIdx, LKToIdx, LRToIdx: integer;
{ Chemin à parcourir, y compris la case d'arrivée. }
  LKingPath, LRookPath, LPath: Int64;
{ Pièces autorisées sur le parcours. }
  LRooks, LKing: Int64;
begin
  LKFrIdx := ToIndex(LKFrCol, LRow);
  LKToIdx := ToIndex(AKToCol, LRow);
  LRFrIdx := ToIndex(LRFrCol, LRow);
  LRToIdx := ToIndex(ARToCol, LRow);
{ Vérification de la première condition : il y a bien une tour à l'endroit prévu. }
  if not IsOn(APos.Pieces[APos.Side] and APos.Rooks, CIndexToSquare[LRFrIdx]) then
    Exit;

{ Deuxième condition : aucune pièce n'est sur le passage du roi ni sur celui de la tour. }
  LKingPath := CPaths[LKFrIdx, LKToIdx] or CIndexToSquare[LKToIdx];
  LRookPath := CPaths[LRFrIdx, LRToIdx] or CIndexToSquare[LRToIdx];
  LPath := LKingPath or LRookPath or CIndexToSquare[LRFrIdx];
  LRooks := APos.Rooks and APos.Pieces[APos.Side];
  LKing  := APos.Kings and APos.Pieces[APos.Side];
  if not (((LPath and LPieces) = (LPath and (LRooks or LKing)))
  and (BitCount(LPath and LRooks) <= 1)) then
    Exit;

{ Dernière condition : aucune des cases sur lesquelles le roi se trouve ou se trouvera n'est menacée. }
  LKingPath := CIndexToSquare[LKFrIdx] or CPaths[LKFrIdx, LKToIdx] or CIndexToSquare[LKToIdx];
  if (LThreats and LKingPath) <> 0 then
    Exit;

{ Enregistrement du coup. Le coup est noté comme la prise de la tour par le roi. }
  SaveMove(LKFrIdx, LRFrIdx);
end;

begin
  LRow := CCastlingRow[APos.Side];
  LPieces := APos.Pieces[FALSE] or APos.Pieces[TRUE];
  LPos := APos;
  LPos.Side := not LPos.Side;
  LThreats := GenerateMoves(LPos) or PotentialPawnCaptures(LPos);
  LKFrCol := SquareToCol(APos.KingSquare[APos.Side]);
  LRFrCol := APos.Castling[APos.Side].HRook;
  if (LRFrCol >= 0) and (LRFrCol <= 7) then
    Search(CColG, CColF);
  LRFrCol := APos.Castling[APos.Side].ARook;
  if (LRFrCol >= 0) and (LRFrCol <= 7) then
    Search(CColC, CColD);
end;

end.
