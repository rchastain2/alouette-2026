{**
  @abstract(Génération des coups.)
  Génération des coups, et fonctions utilisées pour l'évaluation des coups.
}

unit MoveGen;

interface

{ BitAsm dans la partie interface, pour masquer BitCount et BitScanForward de Board : contournement d'un bogue de Blaise (voir bug/bug6). }
uses
  ChessTypes, Board, Chess{$IFDEF BITASM}, BitAsm{$ENDIF};

{** Génération des coups. }
function GenerateMoves(const APos: TPosition; var AList: array of TMove; out ACount: integer; const AQuick: boolean = FALSE; const ExtraPawnMoves: boolean = FALSE): Int64; overload;
{** Cases pouvant être atteintes. }
function GenerateMoves(const APos: TPosition): Int64; overload;
{** Nombre de coups possibles. }
function GetMovesCount(const APos: TPosition): integer;
{** Cases pouvant être prises par les pions. }
function PotentialPawnCaptures(const APos: TPosition): Int64;
{** Pour savoir si le joueur est en échec. }
function IsCheck(const APos: TPosition): boolean;
{** Disposition des pions. }
function PawnStruct(const APos: TPosition): integer;

implementation

uses
  SysUtils, Constants;

{ Constantes au lieu d'ensembles littéraux : contournement d'un bogue de Blaise (voir bug/bug5). }
const
  CCapture: TMoveTypeSet = [mtCapture];
  CEnPassant: TMoveTypeSet = [mtCapture, mtEnPassant];
  CPromotion: TMoveTypeSet = [mtPromotion];
  CPromotionKnight: TMoveTypeSet = [mtPromotion, mtPromotionKnight];
  CPromotionBishop: TMoveTypeSet = [mtPromotion, mtPromotionBishop];
  CPromotionRook: TMoveTypeSet = [mtPromotion, mtPromotionRook];
  CCapturePromotion: TMoveTypeSet = [mtCapture, mtPromotion];
  CCapturePromotionKnight: TMoveTypeSet = [mtCapture, mtPromotion, mtPromotionKnight];
  CCapturePromotionBishop: TMoveTypeSet = [mtCapture, mtPromotion, mtPromotionBishop];
  CCapturePromotionRook: TMoveTypeSet = [mtCapture, mtPromotion, mtPromotionRook];

function GenerateMoves(const APos: TPosition; var AList: array of TMove; out ACount: integer; const AQuick: boolean; const ExtraPawnMoves: boolean): Int64;
var
  LCnt: integer;
{ Variable locale au lieu de result : contournement d'un bogue de Blaise (voir bug/bug3). }
  LResult: Int64;

{ Pas de valeur par défaut pour mt : contournement d'un bogue de Blaise (voir bug/bug4). }
  procedure SaveMove(const i, j: integer; const pt: TPieceType; const mt: TMoveTypeSet);
  begin
    SwitchOn(LResult, CIndexToSquare[j]);
    Inc(LCnt);
    if not AQuick then
      if LCnt <= Length(AList) then
        AList[LCnt - 1] := EncodeMove(i, j, pt, mt);
  end;

const
  CPawn: array[boolean] of TPieceType = (ptWhitePawn, ptBlackPawn);
var
{ Toutes les pièces. }
  LPieces: Int64;
  i, j, k: integer;
  LTargets, LActive, LPassive: Int64;
begin
  LCnt := 0;
  LPieces := APos.Pieces[FALSE] or APos.Pieces[TRUE];
  LActive := APos.Pieces[APos.Side];
  LPassive := APos.Pieces[not APos.Side];
  LResult := 0; { Damier vide. }
  i := BitScanForward(LActive);
  while LActive <> 0 do
  begin
  { Pion. }
    if IsOn(APos.Pawns, CIndexToSquare[i]) then
    begin
      k := 8 - 16 * Ord(APos.Side);
      j := i + k;
      if not IsOn(LPieces, CIndexToSquare[j]) then
      begin
        if ((j div 8 = 7) and not APos.Side)
        or ((j div 8 = 0) and APos.Side) then
        begin
          SaveMove(i, j, CPawn[APos.Side], CPromotion);
          SaveMove(i, j, CPawn[APos.Side], CPromotionKnight);
          SaveMove(i, j, CPawn[APos.Side], CPromotionBishop);
          SaveMove(i, j, CPawn[APos.Side], CPromotionRook);
        end else
          SaveMove(i, j, CPawn[APos.Side], CNoMoveType);
        if ((j div 8 = 2) and not APos.Side)
        or ((j div 8 = 5) and APos.Side) then
        begin
          j := j + k;
          if not IsOn(LPieces, CIndexToSquare[j]) then
            SaveMove(i, j, CPawn[APos.Side], CNoMoveType);
        end;
      end;
    { Captures }
      if i mod 8 > 0 then
      begin
        j := i + k - 1;
        if j = APos.EnPassant then
          SaveMove(i, j, CPawn[APos.Side], CEnPassant)
        else
          if IsOn(LPassive, CIndexToSquare[j]) or ExtraPawnMoves then
            if ((j div 8 = 7) and not APos.Side)
            or ((j div 8 = 0) and APos.Side) then
            begin
              SaveMove(i, j, CPawn[APos.Side], CCapturePromotion);
              SaveMove(i, j, CPawn[APos.Side], CCapturePromotionKnight);
              SaveMove(i, j, CPawn[APos.Side], CCapturePromotionBishop);
              SaveMove(i, j, CPawn[APos.Side], CCapturePromotionRook);
            end else
              SaveMove(i, j, CPawn[APos.Side], CCapture);
      end;
      if i mod 8 < 7 then
      begin
        j := i + k + 1;
        if j = APos.EnPassant then
          SaveMove(i, j, CPawn[APos.Side], CEnPassant)
        else
          if IsOn(LPassive, CIndexToSquare[j]) or ExtraPawnMoves then
            if ((j div 8 = 7) and not APos.Side)
            or ((j div 8 = 0) and APos.Side) then
            begin
              SaveMove(i, j, CPawn[APos.Side], CCapturePromotion);
              SaveMove(i, j, CPawn[APos.Side], CCapturePromotionKnight);
              SaveMove(i, j, CPawn[APos.Side], CCapturePromotionBishop);
              SaveMove(i, j, CPawn[APos.Side], CCapturePromotionRook);
            end else
              SaveMove(i, j, CPawn[APos.Side], CCapture);
      end;
    end else
  { Tour. }
    if IsOn(APos.Rooks, CIndexToSquare[i]) then
    begin
      LTargets := CTargets[ptRook, i] and not APos.Pieces[APos.Side];
      j := BitScanForward(LTargets);
      while LTargets <> 0 do
      begin
        if (CPaths[i, j] and LPieces) = 0 then
          if IsOn(LPassive, CIndexToSquare[j]) then
            SaveMove(i, j, ptRook, CCapture)
          else
            SaveMove(i, j, ptRook, CNoMoveType);
        LTargets := LTargets and not CIndexToSquare[j];
        j := BitScanForward(LTargets);
      end;
    end else
  { Cavalier. }
    if IsOn(APos.Knights, CIndexToSquare[i]) then
    begin
      LTargets := CTargets[ptKnight, i] and not APos.Pieces[APos.Side];
      j := BitScanForward(LTargets);
      while LTargets <> 0 do
      begin
        if IsOn(LPassive, CIndexToSquare[j]) then
          SaveMove(i, j, ptKnight, CCapture)
        else
          SaveMove(i, j, ptKnight, CNoMoveType);
        LTargets := LTargets and not CIndexToSquare[j];
        j := BitScanForward(LTargets);
      end;
    end else
  { Fou. }
    if IsOn(APos.Bishops, CIndexToSquare[i]) then
    begin
      LTargets := CTargets[ptBishop, i] and not APos.Pieces[APos.Side];
      j := BitScanForward(LTargets);
      while LTargets <> 0 do
      begin
        if (CPaths[i, j] and LPieces) = 0 then
          if IsOn(LPassive, CIndexToSquare[j]) then
            SaveMove(i, j, ptBishop, CCapture)
          else
            SaveMove(i, j, ptBishop, CNoMoveType);
        LTargets := LTargets and not CIndexToSquare[j];
        j := BitScanForward(LTargets);
      end;
    end else
  { Dame. }
    if IsOn(APos.Queens, CIndexToSquare[i]) then
    begin
      LTargets := CTargets[ptQueen, i] and not APos.Pieces[APos.Side];
      j := BitScanForward(LTargets);
      while LTargets <> 0 do
      begin
        if (CPaths[i, j] and LPieces) = 0 then
          if IsOn(LPassive, CIndexToSquare[j]) then
            SaveMove(i, j, ptQueen, CCapture)
          else
            SaveMove(i, j, ptQueen, CNoMoveType);
        LTargets := LTargets and not CIndexToSquare[j];
        j := BitScanForward(LTargets);
      end;
    end else
  { Roi. }
    if IsOn(APos.Kings, CIndexToSquare[i]) then
    begin
      LTargets := CTargets[ptKing, i] and not APos.Pieces[APos.Side];
      j := BitScanForward(LTargets);
      while LTargets <> 0 do
      begin
        if IsOn(LPassive, CIndexToSquare[j]) then
          SaveMove(i, j, ptKing, CCapture)
        else
          SaveMove(i, j, ptKing, CNoMoveType);
        LTargets := LTargets and not CIndexToSquare[j];
        j := BitScanForward(LTargets);
      end;
    end;
    LActive := LActive and not CIndexToSquare[i];
    i := BitScanForward(LActive);
  end;
  ACount := LCnt;
  result := LResult;
end;

function GenerateMoves(const APos: TPosition): Int64;
var
  LList: array[0..0] of TMove;
  LCount: integer;
begin
  result := GenerateMoves(APos, LList, LCount, TRUE);
end;

function GetMovesCount(const APos: TPosition): integer;
var
  LList: array[0..0] of TMove;
  LCount: integer;
begin
  GenerateMoves(APos, LList, LCount, TRUE);
  result := LCount;
end;

function PotentialPawnCaptures(const APos: TPosition): Int64;
var
  LPawnType: TPieceType;
  LPawns, LTargets: Int64;
  LFr, LTo: integer;
begin
  if APos.Side then
    LPawnType := ptBlackPawn
  else
    LPawnType := ptWhitePawn;
  result := 0; { Damier vide. }

  LPawns := APos.Pieces[APos.Side] and APos.Pawns;
  while LPawns <> 0 do
  begin
    LFr := BitScanForward(LPawns); LPawns := LPawns and not CIndexToSquare[LFr];

    LTargets := CTargets[LPawnType, LFr];
    while LTargets <> 0 do
    begin
      LTo := BitScanForward(LTargets); LTargets := LTargets and not CIndexToSquare[LTo];

      if not IsOn(APos.Pieces[APos.Side], CIndexToSquare[LTo]) then
          SwitchOn(result, CIndexToSquare[LTo]);
    end;
  end;
end;

function IsCheck(const APos: TPosition): boolean;
var
  LPos: TPosition;
begin
  LPos := APos;
  LPos.Side := not LPos.Side;
  result := (GenerateMoves(LPos) and LPos.Kings) <> 0;
end;

function PawnStruct(const APos: TPosition): integer;
var
  LActivePawns: Int64;
  i, j, k: integer;
begin
  result := 0;
  LActivePawns := APos.Pieces[APos.Side] and APos.Pawns;
  while LActivePawns <> 0 do
  begin
    i := BitScanForward(LActivePawns); LActivePawns := LActivePawns and not CIndexToSquare[i];
    k := 16 * Ord(APos.Side) - 8;
  { Protection côté A. }
    if i mod 8 > 0 then
    begin
      j := i + k - 1;
      if IsOn(APos.Pieces[APos.Side] and APos.Pawns, CIndexToSquare[j]) then
        Inc(result);
    end;
  { Protection côté H. }
    if i mod 8 < 7 then
    begin
      j := i + k + 1;
      if IsOn(APos.Pieces[APos.Side] and APos.Pawns, CIndexToSquare[j]) then
        Inc(result);
    end;
  { Colonne sans pion adverse. }
    if (APos.Pieces[not APos.Side] and APos.Pawns and CColumns[i mod 8]) = 0 then
      Inc(result, 0);
  end;
end;

end.
