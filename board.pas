{**
  @abstract(Échiquier binaire.)
  Représentation d'un échiquier par une variable de 64 chiffres binaires.
}
unit Board;

interface

uses
  ChessTypes;

type
  {** Coup représenté par un nombre entier. }
  TMove = integer;

const
  {** Ensemble vide de types de coup. }
  CNoMoveType: TMoveTypeSet = [];

{** Pour savoir si une case est allumée dans un damier. }
function IsOn(const ABrd, ASqr: Int64): boolean;
{** Allume une case dans un damier. }
procedure SwitchOn(var ABrd: Int64; const ASqr: Int64);
{** Éteint une case. }
procedure SwitchOff(var ABrd: Int64; const ASqr: Int64);

{** Affiche un échiquier binaire dans la sortie standard. }
procedure PrintBoard(const ABrd: Int64);

{** Convertit une chaîne de la forme "a1" en un nombre de 0 à 63. }
function DecodeSquareName(const AName: string): integer;

{** Index pour deux nombres donnés de 0 à 7. }
function ToIndex(const ACol, ARow: integer): integer;
{** Nom d'un coup à partir de l'index des cases. }
function MoveToStr(const AFr, ATo: integer): string; overload;
{** Nom d'un coup à partir de sa représentation par un nombre entier. }
function MoveToStr(const AMove: TMove): string; overload;
{** Conversion d'un coup en nombre entier. }
function EncodeMove(const AFr, ATo: integer; const APieceType: TPieceType; const AMoveType: TMoveTypeSet = CNoMoveType): TMove;
{** Décodage d'un nombre entier représentant un coup. }
procedure DecodeMove(const AMove: TMove; out AFr, ATo: integer); overload;
{** Décodage d'un nombre entier représentant un coup. }
procedure DecodeMove(const AMove: TMove; out AFr, ATo: integer; out APieceType: TPieceTypeWide; out AMoveType: TMoveTypeSet); overload;
{** Décodage d'un nombre entier représentant un coup. }
procedure DecodeMove(const AMove: TMove; out ATo: integer; out AMoveType: TMoveTypeSet); overload;
{** Index de la case d'arrivée pour un coup représenté par un nombre entier. }
function TargetIndex(const AMove: TMove): integer;
{** Type de pièce pour un coup représenté par un nombre entier. }
function PieceType(const AMove: TMove): TPieceType;
{** Type de coup pour un coup représenté par un nombre entier. }
function MoveType(const AMove: TMove): TMoveTypeSet;
{** Index de la case de départ pour un coup représenté par un nombre entier. }
function StartIndex(const AMove: TMove): integer;
{** Nombre de cases allumées dans un damier. }
function BitCount(const ABrd: Int64): integer;

{** Lève une exception si la condition est fausse. }
procedure Assert(const ACondition: boolean; const AMessage: string = 'Assertion failed');

implementation

uses
  SysUtils, Constants;

function IsOn(const ABrd, ASqr: Int64): boolean;
begin
  result := (ABrd and ASqr) = ASqr;
end;

procedure SwitchOn(var ABrd: Int64; const ASqr: Int64);
begin
  ABrd := ABrd or ASqr;
end;

procedure SwitchOff(var ABrd: Int64; const ASqr: Int64);
begin
  ABrd := ABrd and not ASqr;
end;

function BoardToStr(const ABrd: Int64): string;
var
  x, y: integer;
begin
  result := '+   abcdefgh   +' + LineEnding + LineEnding;
  for y := 7 downto 0 do
  begin
    result := result + IntToStr(y + 1) + '   ';
    for x := 0 to 7 do
      result := result + IntToStr(Ord(IsOn(ABrd, CCoordToSquare[x, y])));
    result := result + '   ' + IntToStr(y + 1) + LineEnding;
  end;
  result := result + LineEnding + '+   abcdefgh   +';
end;

procedure PrintBoard(const ABrd: Int64);
begin
  WriteLn(BoardToStr(ABrd));
end;

procedure Assert(const ACondition: boolean; const AMessage: string);
begin
  if not ACondition then
    raise Exception.Create(AMessage);
end;

function DecodeSquareName(const AName: string): integer;
begin
  Assert(Length(AName) = 2);
  Assert((Ord(AName[0]) >= Ord('a')) and (Ord(AName[0]) <= Ord('h')));
  Assert((Ord(AName[1]) >= Ord('1')) and (Ord(AName[1]) <= Ord('8')));
  result := 8 * (Ord(AName[1]) - Ord('1')) + (Ord(AName[0]) - Ord('a'));
end;

function ToIndex(const ACol, ARow: integer): integer;
begin
  result := 8 * ARow + ACol;
end;

function MoveToStr(const AFr, ATo: integer): string;
begin
  result := CSquareNames[AFr] + CSquareNames[ATo];
end;

function MoveToStr(const AMove: TMove): string;
var
  LFr, LTo: integer;
  LPieceType: TPieceTypeWide;
  LMoveType: TMoveTypeSet;
begin
  DecodeMove(AMove, LFr, LTo, LPieceType, LMoveType);
  result := MoveToStr(LFr, LTo);
  if        mtPromotion       in LMoveType then
    if      mtPromotionKnight in LMoveType then result := result + 'n'
    else if mtPromotionBishop in LMoveType then result := result + 'b'
    else if mtPromotionRook   in LMoveType then result := result + 'r'
    else                                        result := result + 'q';
end;

function EncodeMove(const AFr, ATo: integer; const APieceType: TPieceType; const AMoveType: TMoveTypeSet): TMove;
var
  LMoveType: integer;
begin
  LMoveType := 0;
  if mtCastling in AMoveType then
    LMoveType := LMoveType or 2
  else
  begin
    if mtCapture in AMoveType then
      LMoveType := LMoveType or 1;
    if mtEnPassant in AMoveType then
      LMoveType := LMoveType or 4
    else
      if mtPromotion in AMoveType then
      begin
        LMoveType := LMoveType or 8;
        if mtPromotionKnight in AMoveType then
          LMoveType := LMoveType or 16
        else if mtPromotionBishop in AMoveType then
          LMoveType := LMoveType or 32
        else if mtPromotionRook in AMoveType then
          LMoveType := LMoveType or 64;
      end;
  end;
  result := (Ord(APieceType) shl 24) or (LMoveType shl 16) or (AFr shl 8) or ATo;
end;

procedure DecodeMove(const AMove: TMove; out AFr, ATo: integer);
begin
  AFr := (AMove and $0000FF00) shr 8;
  ATo := AMove and $000000FF;
end;

procedure DecodeMove(const AMove: TMove; out AFr, ATo: integer; out APieceType: TPieceTypeWide; out AMoveType: TMoveTypeSet);
var
  LMoveType: integer;
begin
  DecodeMove(AMove, AFr, ATo);
  APieceType := TPieceTypeWide((AMove and $FF000000) shr 24);
  LMoveType := (AMove and $00FF0000) shr 16;
  AMoveType := CNoMoveType;
  if (LMoveType and 2) = 2 then
    AMoveType := AMoveType + [mtCastling]
  else
  begin
    if (LMoveType and 1) = 1 then
      AMoveType := AMoveType + [mtCapture];
    if (LMoveType and 4) = 4 then
      AMoveType := AMoveType + [mtEnPassant]
    else
      if (LMoveType and 8) = 8 then
      begin
        AMoveType := AMoveType + [mtPromotion];
        if      (LMoveType and 16) = 16 then
          AMoveType := AMoveType + [mtPromotionKnight]
        else if (LMoveType and 32) = 32 then
          AMoveType := AMoveType + [mtPromotionBishop]
        else if (LMoveType and 64) = 64 then
          AMoveType := AMoveType + [mtPromotionRook];
      end;
  end;
end;

procedure DecodeMove(const AMove: TMove; out ATo: integer; out AMoveType: TMoveTypeSet);
var
  LFr: integer;
  LPieceType: TPieceTypeWide;
begin
  DecodeMove(AMove, LFr, ATo, LPieceType, AMoveType);
end;

function TargetIndex(const AMove: TMove): integer;
begin
  result := AMove and $000000FF;
end;

function StartIndex(const AMove: TMove): integer;
begin
  result := (AMove and $0000FF00) shr 8;
end;

function PieceType(const AMove: TMove): TPieceType;
begin
  result := TPieceType((AMove and $FF000000) shr 24);
end;

function MoveType(const AMove: TMove): TMoveTypeSet;
var
  LFr, LTo: integer;
  LPieceType: TPieceTypeWide;
  LMoveType: TMoveTypeSet;
begin
  DecodeMove(AMove, LFr, LTo, LPieceType, LMoveType);
  result := LMoveType;
end;

function BitCount(const ABrd: Int64): integer;
var
  x: Int64;
begin
  x := ABrd;
  x := (x and $5555555555555555) + ((x shr  1) and $5555555555555555);
  x := (x and $3333333333333333) + ((x shr  2) and $3333333333333333);
  x := (x and $0F0F0F0F0F0F0F0F) + ((x shr  4) and $0F0F0F0F0F0F0F0F);
  x := (x and $00FF00FF00FF00FF) + ((x shr  8) and $00FF00FF00FF00FF);
  x := (x and $0000FFFF0000FFFF) + ((x shr 16) and $0000FFFF0000FFFF);
  x := (x and $00000000FFFFFFFF) + ((x shr 32) and $00000000FFFFFFFF);
  result := x;
end;

end.
