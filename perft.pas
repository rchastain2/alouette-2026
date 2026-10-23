{**
  @abstract(Essai de performance.)
  Génération chronométrée des coups légaux jusqu'à une profondeur donnée.
  Permet d'évaluer la performance du générateur de coups, et de détecter les éventuelles erreurs,
  en comparant les résultats obtenus avec ceux d'autres programmes.
}

unit Perft;

interface

uses
  Chess;

function Start(const AIniPos: TPosition; const ADepth: integer; const AOutput: boolean = TRUE): integer;
procedure DisplayLegalMoves(const APos: TPosition);

implementation

uses
  SysUtils, Classes, DateUtils, ChessTypes, Board, MoveGen, Castling, Move;

function IsLegal(const APos: TPosition; const AMove: TMove): boolean;
var
  LPos: TPosition;
begin
  LPos := APos;
  result := FALSE;
  if DoMove(LPos, AMove) then
    result := (
      GenerateMoves(LPos)
      and LPos.Pieces[not LPos.Side]
      and LPos.Kings
    ) = 0;
end;

function ZeroPad(const AValue: Int64; const AWidth: integer): string;
begin
  result := IntToStr(AValue);
  while Length(result) < AWidth do
    result := '0' + result;
end;

function Start(const AIniPos: TPosition; const ADepth: integer; const AOutput: boolean): integer;
var
  LRes: array of integer;

  procedure GetMovesCount(const APos: TPosition; const ARecurse: integer);
  var
    LList, LList2: array[0..255] of TMove;
    LCount, LLegalCount, i: integer;
    LPos: TPosition;
  begin
    GenerateMoves(APos, LList, LCount);
    GenerateCastling(APos, LList, LCount);
    LLegalCount := 0;
    for i := 0 to LCount - 1 do
      if IsLegal(APos, LList[i]) then
      begin
        LList2[LLegalCount] := LList[i];
        Inc(LLegalCount);
      end;
    Inc(LRes[ADepth - ARecurse - 1], LLegalCount);

    if ARecurse > 0 then
      for i := 0 to LLegalCount - 1 do
      begin
        LPos := APos;
        if DoMove(LPos, LList2[i]) then
          GetMovesCount(LPos, ARecurse - 1)
        else
        begin
          WriteLn('Unexpected error');
          Exit;
        end;
      end;
  end;

var
  i: integer;
  t: Int64;
  s: string;
begin
  if ADepth < 1 then
    Exit(0);
  SetLength(LRes, ADepth);
  for i := 0 to ADepth - 1 do
    LRes[i] := 0;

  t := InstantNow().ToUnixMillis();
  GetMovesCount(AIniPos, ADepth - 1);
  t := InstantNow().ToUnixMillis() - t;

  result := LRes[ADepth - 1];

  if AOutput then
  begin
    s := Format('Perft(%%%dd) = %%%dd', [Length(IntToStr(ADepth)), Length(IntToStr(LRes[ADepth - 1]))]);
    for i := 0 to ADepth - 1 do
      WriteLn(Format(s, [i + 1, LRes[i]]));
    WriteLn('Time elapsed: ', ZeroPad(t div 3600000, 2), ':', ZeroPad(t div 60000 mod 60, 2), ':', ZeroPad(t div 1000 mod 60, 2), ':', ZeroPad(t mod 1000, 3));
  end;

  SetLength(LRes, 0);
end;

procedure DisplayLegalMoves(const APos: TPosition);
var
  LList: array[0..255] of TMove;
  LCount, i: integer;
  LMoves: TStringList;
  LSqr, LPrevSqr: string;
begin
  LMoves := TStringList.Create;
  LMoves.Sorted := TRUE;

  GenerateMoves(APos, LList, LCount);
  GenerateCastling(APos, LList, LCount);

  for i := 0 to LCount - 1 do
    if IsLegal(APos, LList[i]) then
      LMoves.Add(MoveToStr(LList[i]));

  WriteLn(Format('%d legal moves', [LMoves.Count]));

  if LMoves.Count > 0 then
  begin
    LPrevSqr := Copy(LMoves[0], 0, 2);
    for i := 0 to LMoves.Count - 1 do
    begin
      LSqr := Copy(LMoves[i], 0, 2);
      if LSqr = LPrevSqr then
        Write(Format('%-6s', [LMoves[i]]))
      else
      begin
        LPrevSqr := LSqr;
        Write(LineEnding, Format('%-6s', [LMoves[i]]));
      end;
    end;
    WriteLn();
  end;

  LMoves.Free();
end;

end.
