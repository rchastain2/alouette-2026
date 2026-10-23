
program CastlingDemo;

uses
  SysUtils, Classes, ChessTypes, Board, Chess, Castling;

const
  CFileName = 'castling960.fen';
  CShown = 5;

var
  LList: TStringList;
  LPos: TPosition;
  LMoves: array[0..255] of TMove;
  LCount, i, j: integer;
  LTotal: array[0..2] of integer;
  s: string;

begin
  for j := 0 to 2 do
    LTotal[j] := 0;
  LList := TStringList.Create;
  try
    LList.LoadFromFile(CFileName);
    for i := 0 to LList.Count - 1 do
    begin
      LPos := EncodePosition(LList[i], TRUE);
      LCount := 0;
      GenerateCastling(LPos, LMoves, LCount);
      LTotal[LCount] := LTotal[LCount] + 1;
      if i >= LList.Count - CShown then
      begin
        s := '';
        for j := 0 to LCount - 1 do
          s := s + ' ' + MoveToStr(LMoves[j]);
        WriteLn(LList[i], ' ->', s);
      end;
    end;
    WriteLn('Positions: ', LList.Count);
    for j := 0 to 2 do
      WriteLn('Castling moves: ', j, ', positions: ', LTotal[j]);
  finally
    LList.Free();
  end;
end.
