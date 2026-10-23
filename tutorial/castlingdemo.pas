
program CastlingDemo;

uses
  SysUtils, Classes, ChessTypes, Board, Chess, Castling;

const
{ Positions Chess960 où le roque est possible. }
  CFileName = 'castling960.fen';
{ Nombre de positions affichées, à la fin du fichier. }
  CShown = 5;

var
  LList: TStringList;
  LPos: TPosition;
  LMoves: array[0..255] of TMove;
  LCount, i, j: integer;
{ Nombre de positions pour chaque nombre de roques possibles. }
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
    { Initialisation d'une position à partir d'une chaîne FEN, en mode Chess960. }
      LPos := EncodePosition(LList[i], TRUE);
    { Génération des roques possibles. }
      LCount := 0;
      GenerateCastling(LPos, LMoves, LCount);
      LTotal[LCount] := LTotal[LCount] + 1;
    { Affichage des roques. Le roque est noté comme la prise de la tour par le roi. }
      if i >= LList.Count - CShown then
      begin
        s := '';
        for j := 0 to LCount - 1 do
          s := s + ' ' + MoveToStr(LMoves[j]);
        WriteLn(LList[i], ' ->', s);
      end;
    end;
  { Bilan. }
    WriteLn('Positions: ', LList.Count);
    for j := 0 to 2 do
      WriteLn('Castling moves: ', j, ', positions: ', LTotal[j]);
  finally
    LList.Free();
  end;
end.

{
  bqnb1rkr/pp3ppp/3ppn2/2p5/5P2/P2P4/NPP1P1PP/BQ1BNRKR w HFhf - 2 9 ->
  2nnrbkr/p1qppppp/8/1ppb4/6PP/3PP3/PPP2P2/BQNNRBKR w HEhe - 1 9 ->
  b1q1rrkb/pppppppp/3nn3/8/P7/1PPP4/4PPPP/BQNNRKRB w GE - 1 9 -> f1g1
  qbbnnrkr/2pp2pp/p7/1p2pp2/8/P3PP2/1PPP1KPP/QBBNNR1R w hf - 0 9 ->
  1nbbnrkr/p1p1ppp1/3p4/1p3P1p/3Pq2P/8/PPP1P1P1/QNBBNRKR w HFhf - 0 9 ->
  Positions: 1925
  Castling moves: 0, positions: 4
  Castling moves: 1, positions: 181
  Castling moves: 2, positions: 1740
}
