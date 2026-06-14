
program Targets;

uses
  SysUtils, Board;

function IsPossible(const APiece: TPieceType; const AX1, AY1, AX2, AY2: integer): boolean;
var
  dx, dy, ax, ay: integer;
begin
  dx := AX2 - AX1;
  dy := AY2 - AY1;
  ax := Abs(dx);
  ay := Abs(dy);
  case APiece of
    ptWhitePawn: result := (dy = 1) and (ax = 1);
    ptBlackPawn: result := (dy = -1) and (ax = 1);
    ptRook:      result := (dx = 0) xor (dy = 0);
    ptKnight:    result := ax * ay = 2;
    ptBishop:    result := (dx <> 0) and (ax = ay);
    ptQueen:     result := IsPossible(ptRook, AX1, AY1, AX2, AY2) or IsPossible(ptBishop, AX1, AY1, AX2, AY2);
    ptKing:      result := (ax + ay <= 2) and ((ax = 1) or (ay = 1));
  end;
end;

function GetTargets(const APiece: TPieceType; const AIdx: integer): int64;
var
  x1, y1, x2, y2: integer;
begin
  x1 := AIdx mod 8;
  y1 := AIdx div 8;
  result := 0;
  for y2 := 7 downto 0 do
    for x2 := 0 to 7 do
      if IsPossible(APiece, x1, y1, x2, y2) then
        SetBitTo1(result, {ToBoard(x2, y2)}CCoordToSquare[x2, y2]);
end;

const
  CComma: array[boolean] of string = ('', ',');
  
var
  x, y: integer;
  LType: TPieceType;
  LBoard: int64;
  
begin
  for LType in TPieceType do
  begin
    WriteLn('(');
    for y := 0 to 7 do
      for x := 0 to 7 do
      begin
        LBoard := GetTargets(LType, 8 * y + x);
        Write(' $', IntToHex(LBoard, 16));
        Write(CComma[8 * y + x < 63]);
        if (x = 7) or (x = 3) then
          WriteLn();
      end;
    WriteLn(')', CComma[LType < ptKing]);
  end;
end. 
