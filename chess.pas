{**
  @abstract(Lecture et écriture d'une position dans une chaîne de caractères au format EPD.)
  Les quatre groupes de caractères d'une chaîne EPD correspondent aux quatre premiers groupes de caractères d'une chaîne @html(<a href="http://kirill-kryukov.com/chess/doc/fen.html">FEN</a>).
}
unit Chess;

interface

uses
  Board, Constants, ChessTypes;

const
  CWhite = FALSE;
  CBlack = TRUE;
  CNil = -1;
  
type
  {**
    Droit de roquer.
    Lorsque le roque est permis, la variable indique la colonne où se trouve la tour (de 0 à 7).
    Lorsque le roque est interdit, la variable reçoit la valeur -1 (CNil).
  }
  TCastlingData = record
    HRook,
    ARook: integer;
  end;
  
  TCastling = array[boolean] of TCastlingData;
  
  TPosition = record
    Pieces: array[boolean] of Int64;
    Pawns,
    Rooks,
    Knights,
    Bishops,
    Queens,
    Kings: Int64;
    Side: boolean;
    Castling: TCastling;
    EnPassant: integer;
    KingSquare: array[boolean] of Int64;
  end;

type
  TCastlingRow = array[boolean] of integer;

const
  CStartPos = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -';
  CColC = 2;
  CColD = 3;
  CColE = 4;
  CColF = 5;
  CColG = 6;
  CRow1 = 0;
  CRow8 = 7;
  CCastlingRow: TCastlingRow = (CRow1, CRow8);
  
type
  TRookSquare = array[boolean] of integer;
  
const
  CATCR: TRookSquare = (F1, F8); { Arrivée tour côté roi.  }
  CATCD: TRookSquare = (D1, D8); { Arrivée tour côté dame. }
  CDTCR: TRookSquare = (H1, H8); { Départ tour côté roi.   }
  CDTCD: TRookSquare = (A1, A8); { Départ tour côté dame.  }

function NewPosition: TPosition;
function IsValidFen(const AFen: string): boolean;
function EncodePosition(const APos: string = CStartPos; const AChess960: boolean = FALSE): TPosition;
function DecodePosition(const APos: TPosition; const AChess960: boolean = FALSE): string;
function SquareToCol(const ASqr: Int64): integer;
function PosToText(const APos: TPosition): string;

implementation

uses
  SysUtils, Classes;

procedure Reinitialize(out ACastling: TCastling);
var
  LSide: boolean;
begin
  for LSide := CWhite to CBlack do
  begin
    ACastling[LSide].HRook := CNil;
    ACastling[LSide].ARook := CNil;
  end;
end;

{ Variable locale au lieu de result : contournement d'un bogue de Blaise (voir bug/bug1). }
function DecodeTraditionalCastlingString(const ACastlingStr: string): TCastling;
var
  LCastling: TCastling;
begin
  Reinitialize(LCastling);
  if Pos('K', ACastlingStr) >= 0 then LCastling[CWhite].HRook := 7;
  if Pos('Q', ACastlingStr) >= 0 then LCastling[CWhite].ARook := 0;
  if Pos('k', ACastlingStr) >= 0 then LCastling[CBlack].HRook := 7;
  if Pos('q', ACastlingStr) >= 0 then LCastling[CBlack].ARook := 0;
  result := LCastling;
end;

{ Variable locale au lieu de result : contournement d'un bogue de Blaise (voir bug/bug1). }
function DecodeCastlingString(const ACastlingStr: string; const AWhiteKingCol, ABlackKingCol: integer): TCastling;
const
{
  CChar: array[boolean, 0..7] of char = (
    ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'),
    ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h')
  );
}
  CColumnsForWhite = 'ABCDEFGH';
  CColumnsForBlack = 'abcdefgh';
var
 {c1, c2: char;
  b: boolean;
  a: byte;}
  LCol: integer;
  LCastling: TCastling;
begin
  Reinitialize(LCastling);
  {
  for b := CWhite to CBlack do
  begin
    a := Ord(CChar[b, 0]);
    if b then c1 := Chr(AWhiteKingCol + a) else c1 := Chr(ABlackKingCol + a);
    for c2 := CChar[b, 7] downto Succ(c1) do if Pos(c2, ACastlingStr) > 0 then result[b].HRook := Ord(c2) - a;
    for c2 := CChar[b, 0] to Pred(c1) do if Pos(c2, ACastlingStr) > 0 then result[b].ARook := Ord(c2) - a;
  end;
  }
  for LCol := 7 downto AWhiteKingCol + 1 do if Pos(Copy(CColumnsForWhite, LCol, 1), ACastlingStr) > -1 then begin LCastling[CWhite].HRook := LCol; Break; end;
  for LCol := 0     to AWhiteKingCol - 1 do if Pos(Copy(CColumnsForWhite, LCol, 1), ACastlingStr) > -1 then begin LCastling[CWhite].ARook := LCol; Break; end;
  for LCol := 7 downto ABlackKingCol + 1 do if Pos(Copy(CColumnsForBlack, LCol, 1), ACastlingStr) > -1 then begin LCastling[CBlack].HRook := LCol; Break; end;
  for LCol := 0     to ABlackKingCol - 1 do if Pos(Copy(CColumnsForBlack, LCol, 1), ACastlingStr) > -1 then begin LCastling[CBlack].ARook := LCol; Break; end;
  result := LCastling;
end;

function EncodeCastlingString(const ACastling: TCastling; const AChess960: boolean = FALSE): string;
begin
  result := '';
  if AChess960 then
  begin
    if (ACastling[CWhite].HRook >= 0) and (ACastling[CWhite].HRook <= 7) then result := result + Chr(ACastling[CWhite].HRook + Ord('A'));
    if (ACastling[CWhite].ARook >= 0) and (ACastling[CWhite].ARook <= 7) then result := result + Chr(ACastling[CWhite].ARook + Ord('A'));
    if (ACastling[CBlack].HRook >= 0) and (ACastling[CBlack].HRook <= 7) then result := result + Chr(ACastling[CBlack].HRook + Ord('a'));
    if (ACastling[CBlack].ARook >= 0) and (ACastling[CBlack].ARook <= 7) then result := result + Chr(ACastling[CBlack].ARook + Ord('a'));
  end else
  begin
    if ACastling[CWhite].HRook <> CNil then result := result + 'K';
    if ACastling[CWhite].ARook <> CNil then result := result + 'Q';
    if ACastling[CBlack].HRook <> CNil then result := result + 'k';
    if ACastling[CBlack].ARook <> CNil then result := result + 'q';
  end;
  if result = '' then
    result := '-';
end;

function SquareToCol(const ASqr: Int64): integer;
var
  x: integer;
begin
  result := CNil;
  x := 0;
  while (result = CNil) and (x <= 7) do
    if IsOn(CColumns[x], ASqr) then
      result := x
    else
      Inc(x);
end;

function NewPosition: TPosition;
begin
  result.Pieces[CWhite] := 0;
  result.Pieces[CBlack] := 0;
  result.Pawns := 0;
  result.Rooks := 0;
  result.Knights := 0;
  result.Bishops := 0;
  result.Queens := 0;
  result.Kings := 0;
  result.Side := FALSE;
  result.Castling[CWhite].HRook := CNil;
  result.Castling[CWhite].ARook := CNil;
  result.Castling[CBlack].HRook := CNil;
  result.Castling[CBlack].ARook := CNil;
  result.EnPassant := CNil;
  result.KingSquare[CWhite] := 0;
  result.KingSquare[CBlack] := 0;
end;

function IsValidFen(const AFen: string): boolean;
var
  LFields: TStringList;
  LBoard, LEnPassant: string;
  x, y, i: integer;
  c: integer;
begin
  result := FALSE;
  LFields := TStringList.Create;
  try
    LFields.Text := ReplaceAll(AFen, Chr(32), Chr(10));
    if (LFields.Count <> 4) and (LFields.Count <> 6) then
      Exit;
    LBoard := LFields[0];
    x := 0;
    y := 7;
    i := 0;
    while i < Length(LBoard) do
    begin
      c := OrdAt(LBoard, i);
      if c = Ord('/') then
      begin
        if (x <> 8) or (y = 0) then
          Exit;
        x := 0;
        y := y - 1;
      end else
      if (c >= Ord('1')) and (c <= Ord('8')) then
        x := x + c - Ord('0')
      else
      if Pos(Chr(c), 'PRNBQKprnbqk') > -1 then
        x := x + 1
      else
        Exit;
      i := i + 1;
    end;
    if (x <> 8) or (y <> 0) then
      Exit;
    if (LFields[1] <> 'w') and (LFields[1] <> 'b') then
      Exit;
    LEnPassant := LFields[3];
    result := (LEnPassant = '-')
      or (Length(LEnPassant) = 2)
      and (OrdAt(LEnPassant, 0) >= Ord('a')) and (OrdAt(LEnPassant, 0) <= Ord('h'))
      and (OrdAt(LEnPassant, 1) >= Ord('1')) and (OrdAt(LEnPassant, 1) <= Ord('8'));
  finally
    LFields.Free();
  end;
end;

function EncodePosition(const APos: string; const AChess960: boolean): TPosition;
const
  CEpdCount = 4;
  CFenCount = 6;
var
  x, y, i: integer;
  c: integer;
  LSqr: Int64;
  LList: TStringList;
begin
  result := NewPosition();
  LList := TStringList.Create;
  try
    LList.Text := ReplaceAll(APos, Chr(32), Chr(10));
    Assert((LList.Count = CEpdCount) or (LList.Count = CFenCount));
    x := 0;
    y := 7;
    i := 0;
    while i < Length(LList[0]) do
    begin
      c := OrdAt(LList[0], i);
      if c = Ord('/') then
      begin
        x := 0;
        y := y - 1;
      end else
      if (c >= Ord('1')) and (c <= Ord('8')) then
      begin
        x := x + c - Ord('0');
      end else
      begin
        LSqr := CCoordToSquare[x, y];
        SwitchOn(result.Pieces[(c = Ord('p')) or (c = Ord('r')) or (c = Ord('n')) or (c = Ord('b')) or (c = Ord('q')) or (c = Ord('k'))], LSqr);

        if (c = Ord('p')) or (c = Ord('P')) then SwitchOn(result.Pawns,   LSqr) else
        if (c = Ord('r')) or (c = Ord('R')) then SwitchOn(result.Rooks,   LSqr) else
        if (c = Ord('n')) or (c = Ord('N')) then SwitchOn(result.Knights, LSqr) else
        if (c = Ord('b')) or (c = Ord('B')) then SwitchOn(result.Bishops, LSqr) else
        if (c = Ord('q')) or (c = Ord('Q')) then SwitchOn(result.Queens,  LSqr) else
        if (c = Ord('k')) or (c = Ord('K')) then
        begin
          SwitchOn(result.Kings, LSqr);
          result.KingSquare[c = Ord('k')] := LSqr;
        end;

        x := x + 1;
      end;

      i := i + 1;
    end;
    result.Side := LList[1] = {CSideSymbol[CBlack]}'b';
    if AChess960 then
      result.Castling := DecodeCastlingString(LList[2], SquareToCol(result.KingSquare[CWhite]), SquareToCol(result.KingSquare[CBlack]))
    else
      result.Castling := DecodeTraditionalCastlingString(LList[2]);
    if LList[3] = '-' then
      result.EnPassant := CNil
    else
      result.EnPassant := DecodeSquareName(LList[3]);
  finally
    LList.Free();
  end;
end;

function DecodePosition(const APos: TPosition; const AChess960: boolean): string;
var
  x, y, n: integer;
  c: integer;
  LEnPassantStr: string;
  LSideSymbol: string;
begin
  result := '';
  x := 0;
  y := 7;
  while y >= 0 do
  begin
    if (APos.Pieces[FALSE] or APos.Pieces[TRUE]) and CCoordToSquare[x, y] = 0 then
    begin
      n := 0;
      while (x + n <= 7) and ((APos.Pieces[FALSE] or APos.Pieces[TRUE]) and CCoordToSquare[x + n, y] = 0) do
        Inc(n);
      result := result + IntToStr(n);
      Inc(x, n);
    end else
    begin
      c := Ord('?');
      if IsOn(APos.Pawns,        CCoordToSquare[x, y]) then c := Ord('P') else
      if IsOn(APos.Rooks,        CCoordToSquare[x, y]) then c := Ord('R') else
      if IsOn(APos.Knights,      CCoordToSquare[x, y]) then c := Ord('N') else
      if IsOn(APos.Bishops,      CCoordToSquare[x, y]) then c := Ord('B') else
      if IsOn(APos.Queens,       CCoordToSquare[x, y]) then c := Ord('Q') else
      if IsOn(APos.Kings,        CCoordToSquare[x, y]) then c := Ord('K');
      if IsOn(APos.Pieces[TRUE], CCoordToSquare[x, y]) then
        c := c + 32;
      result := result + Chr(c);
      x := x + 1;
    end;
    if x > 7 then
    begin
      if y > 0 then
        result := result + '/';
      x := 0;
      y := y - 1;
    end;
  end;
  if APos.EnPassant = CNil then
    LEnPassantStr := '-'
  else
    LEnPassantStr := CSquareNames[APos.EnPassant];
  if APos.Side then
    LSideSymbol := 'b'
  else
    LSideSymbol := 'w';
  result := Format(
    '%s %s %s %s',
    [
      result,
      LSideSymbol,
      EncodeCastlingString(APos.Castling, AChess960),
      LEnPassantStr
    ]
  );
end;

function PosToText(const APos: TPosition): string;
const
  CActive: array[boolean] of string = ('', ' *');
const
  CFormat =
    '+  A B C D E F G H  +%s'+ LineEnding +
    '8 |%s|%s|%s|%s|%s|%s|%s|%s| 8'+ LineEnding +
    '7 |%s|%s|%s|%s|%s|%s|%s|%s| 7'+ LineEnding +
    '6 |%s|%s|%s|%s|%s|%s|%s|%s| 6'+ LineEnding +
    '5 |%s|%s|%s|%s|%s|%s|%s|%s| 5'+ LineEnding +
    '4 |%s|%s|%s|%s|%s|%s|%s|%s| 4'+ LineEnding +
    '3 |%s|%s|%s|%s|%s|%s|%s|%s| 3'+ LineEnding +
    '2 |%s|%s|%s|%s|%s|%s|%s|%s| 2'+ LineEnding +
    '1 |%s|%s|%s|%s|%s|%s|%s|%s| 1'+ LineEnding +
    '+  A B C D E F G H  +%s'+ LineEnding +
    'Castling: %s'+ LineEnding +
    'En passant: %s'+ LineEnding +
    'FEN: %s';
var
  x, y: integer;
  c: array[0..7, 0..7] of string;
  i: integer;
  s: string;
  sqr: Int64;
begin
  for y := 7 downto 0 do
    for x := 0 to 7 do
    begin
      i := 8 * y + x;
      c[x, y] := '?';
      sqr := CIndexToSquare[i];
      if IsOn(APos.Pawns,   sqr) then c[x, y] := 'p' else
      if IsOn(APos.Rooks,   sqr) then c[x, y] := 'r' else
      if IsOn(APos.Knights, sqr) then c[x, y] := 'n' else
      if IsOn(APos.Bishops, sqr) then c[x, y] := 'b' else
      if IsOn(APos.Queens,  sqr) then c[x, y] := 'q' else
      if IsOn(APos.Kings,   sqr) then c[x, y] := 'k' else
        if (x + y) mod 2 = 1 then
          c[x, y] := '.'
        else
          c[x, y] := ':';
      if IsOn(APos.Pieces[FALSE], sqr) then
        c[x, y] := UpCase(c[x, y]);
    end;
    if APos.EnPassant = CNil then
      s := '-'
    else
      s := CSquareNames[APos.EnPassant];
  result := Format(CFormat, [
    CActive[APos.Side],
    c[0, 7], c[1, 7], c[2, 7], c[3, 7], c[4, 7], c[5, 7], c[6, 7], c[7, 7],
    c[0, 6], c[1, 6], c[2, 6], c[3, 6], c[4, 6], c[5, 6], c[6, 6], c[7, 6],
    c[0, 5], c[1, 5], c[2, 5], c[3, 5], c[4, 5], c[5, 5], c[6, 5], c[7, 5],
    c[0, 4], c[1, 4], c[2, 4], c[3, 4], c[4, 4], c[5, 4], c[6, 4], c[7, 4],
    c[0, 3], c[1, 3], c[2, 3], c[3, 3], c[4, 3], c[5, 3], c[6, 3], c[7, 3],
    c[0, 2], c[1, 2], c[2, 2], c[3, 2], c[4, 2], c[5, 2], c[6, 2], c[7, 2],
    c[0, 1], c[1, 1], c[2, 1], c[3, 1], c[4, 1], c[5, 1], c[6, 1], c[7, 1],
    c[0, 0], c[1, 0], c[2, 0], c[3, 0], c[4, 0], c[5, 0], c[6, 0], c[7, 0],
    CActive[not APos.Side],
    EncodeCastlingString(APos.Castling, TRUE),
    s,
    DecodePosition(APos, TRUE)
  ]);
end;

end.
