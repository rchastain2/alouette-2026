
unit Board;

interface

type
  TPieceType = (ptWhitePawn, ptBlackPawn, ptRook, ptKnight, ptBishop, ptQueen, ptKing);

function ToBoard(const AIdx: integer): int64;
function ToIndex(const ACol, ARow: integer): integer;
function Is1(const ABrd, ASqr: Int64): boolean;
procedure SetBitTo1(var ABrd: Int64; const ASqr: Int64);
procedure SetBitTo0(var ABrd: Int64; const ASqr: Int64);
function GetPath(const AFr, ATo: integer): int64;
function IsPossible(const APiece: TPieceType; const AX1, AY1, AX2, AY2: integer): boolean;
function GetTargets(const APiece: TPieceType; const AIdx: integer): int64;

implementation

function ToBoard(const AIdx: integer): int64;
begin
  result := int64(1) shl AIdx;
end;

function ToIndex(const ACol, ARow: integer): integer;
begin
  result := 8 * ARow + ACol;
end;

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

function GetPath(const AFr, ATo: integer): int64;
var
  x1, y1, x2, y2, dx, dy: integer;
begin
  result := 0;
  x1 := AFr mod 8;
  y1 := AFr div 8;
  x2 := ATo mod 8;
  y2 := ATo div 8;
  dx := x2 - x1;
  dy := y2 - y1;
  if ((dx <> 0) or (dy <> 0))
  and (((dx = 0) or (dy = 0)) or (Abs(dx) = Abs(dy))) then
  begin
    if dx <> 0 then dx := dx div Abs(dx);
    if dy <> 0 then dy := dy div Abs(dy);
    repeat
      Inc(x1, dx);
      Inc(y1, dy);
      if (x1 <> x2)
      or (y1 <> y2) then
        result := result or {CCoordToSquare[x1, y1]}(ToBoard(ToIndex(x1, y1)));
    until (x1 = x2) and (y1 = y2);
  end;
end;

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
        SetBitTo1(result, ToBoard(ToIndex(x2, y2)){CCoordToSquare[x2, y2]});
end;

end. 
