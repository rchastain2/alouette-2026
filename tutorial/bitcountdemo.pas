
program BitCountDemo;

uses
  SysUtils, Board, Constants, ChessTypes, BitCountAsm;

{$ASSERTIONS ON}

type
  TBitCountFunc = function(const ABrd: Int64): integer;

function BC1(const ABrd: Int64): integer;
var
  LIdx: integer;
begin
  result := 0;
  for LIdx := A1 to H8 do
    if IsOn(ABrd, CIndexToSquare[LIdx]) then
      Inc(result);
end;

function BC2(const ABrd: Int64): integer;
const
  C0 = Int64(0);
  C1 = Int64(1);
var
  LBrd: Int64;
begin
  result := 0;
  LBrd := ABrd;
  while LBrd <> C0 do
  begin
    if LBrd and C1 = C1 then
      Inc(result);
    LBrd := LBrd shr 1;
  end;
end;

{ https://www.developpez.net/forums/d2001819/autres-langages/assembleur/x86-32-bits-64-bits/reecriture-pascal-d-fonction-assembleur/ }

function BC3(const ABrd: Int64): integer;
var
  X: Int64;
begin
  X := ABrd;
  X := (X and $5555555555555555) + ((X shr  1) and $5555555555555555);
  X := (X and $3333333333333333) + ((X shr  2) and $3333333333333333);
  X := (X and $0F0F0F0F0F0F0F0F) + ((X shr  4) and $0F0F0F0F0F0F0F0F);
  X := (X and $00FF00FF00FF00FF) + ((X shr  8) and $00FF00FF00FF00FF);
  X := (X and $0000FFFF0000FFFF) + ((X shr 16) and $0000FFFF0000FFFF);
  X := (X and $00000000FFFFFFFF) + ((X shr 32) and $00000000FFFFFFFF);
  result := integer(X);
end;

function BC4(const ABrd: Int64): integer;
var
  LBrd: Int64;
begin
  LBrd := ABrd;
  result := BitCount3264(LBrd);
end;

function BC5(const ABrd: Int64): integer;
var
  LBrd: Int64;
begin
  LBrd := ABrd;
  result := BitCount64(LBrd);
end;

function BC6(const ABrd: Int64): integer;
var
  LBrd: Int64;
begin
  LBrd := ABrd;
  result := PopCnt(UInt64(LBrd));
end;

procedure Test(ABrd: Int64; AResult: integer; AFunc: TBitCountFunc);
begin
  Assert(AFunc(ABrd) = AResult);
end;

procedure TimeTest(ABrd: Int64; AFunc: TBitCountFunc);
var
  LClock: cardinal;
  n: integer;
begin
  LClock := GetTickCount64;
  for n := 1 to 1000000 do
    AFunc(ABrd);
  WriteLn(GetTickCount64 - LClock);
end;

const
  CBrd = %0100001000000000000000000000000000000000000000000000000001000010;

begin
  Test(CBrd, 4, @BC1);
  Test(CBrd, 4, @BC2);
  Test(CBrd, 4, @BC3);
  Test(CBrd, 4, @BC4);
  Test(CBrd, 4, @BC5);
  Test(CBrd, 4, @BC6);
  
  Test(CWhiteSquares, 32, @BC1);
  Test(CWhiteSquares, 32, @BC2);
  Test(CWhiteSquares, 32, @BC3);
  Test(CWhiteSquares, 32, @BC4);
  Test(CWhiteSquares, 32, @BC5);
  Test(CWhiteSquares, 32, @BC6);
  
  TimeTest(CBrd, @BC1);
  TimeTest(CBrd, @BC2);
  TimeTest(CBrd, @BC3);
  TimeTest(CBrd, @BC4);
  TimeTest(CBrd, @BC5);
  TimeTest(CBrd, @BC6);
end.
