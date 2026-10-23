
program PerftDemo;

uses
  SysUtils, Chess, Perft;

const
{ Profondeur de l'essai. }
  CDepth = 3;
{ Positions de référence : position initiale, "Kiwipete", positions 3 à 6. }
  CPositions: array[0..5] of string = (
    'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    'r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1',
    '8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1',
    'r3k2r/Pppp1ppp/1b3nbN/nP6/BBP1P3/q4N2/Pp1P2PP/R2Q1RK1 w kq - 0 1',
    'rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ - 1 8',
    'r4rk1/1pp1qppp/p1np1n2/2b1p1B1/2B1P1b1/P1NP1N2/1PP1QPPP/R4RK1 w - - 0 10'
  );
{ Résultats attendus à la profondeur 3. }
  CExpected: array[0..5] of integer = (8902, 97862, 2812, 9467, 62379, 89890);

var
  i, LCount: integer;

begin
{ Affichage des coups légaux dans la position initiale. }
  DisplayLegalMoves(EncodePosition(CPositions[0]));
  WriteLn();
{ Nombre de positions atteintes à la profondeur donnée, comparé au résultat attendu. }
  for i := 0 to 5 do
  begin
    LCount := Start(EncodePosition(CPositions[i]), CDepth, FALSE);
    WriteLn(Format('Perft(%d) = %5d (expected %5d) %s', [CDepth, LCount, CExpected[i], CPositions[i]]));
  end;
end.

{
  20 legal moves
  a2a3  a2a4
  b1a3  b1c3
  b2b3  b2b4
  c2c3  c2c4
  d2d3  d2d4
  e2e3  e2e4
  f2f3  f2f4
  g1f3  g1h3
  g2g3  g2g4
  h2h3  h2h4

  Perft(3) =  8902 (expected  8902) rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
  Perft(3) = 97862 (expected 97862) r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1
  Perft(3) =  2812 (expected  2812) 8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1
  Perft(3) =  9467 (expected  9467) r3k2r/Pppp1ppp/1b3nbN/nP6/BBP1P3/q4N2/Pp1P2PP/R2Q1RK1 w kq - 0 1
  Perft(3) = 62379 (expected 62379) rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ - 1 8
  Perft(3) = 89890 (expected 89890) r4rk1/1pp1qppp/p1np1n2/2b1p1B1/2B1P1b1/P1NP1N2/1PP1QPPP/R4RK1 w - - 0 10
}
