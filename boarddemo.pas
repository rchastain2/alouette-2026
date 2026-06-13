
program BoardDemo;

uses
  Board;

const
{ Toutes les pièces blanches (position de départ conventionnelle). }
  CWhitePieces = %0000000000000000000000000000000000000000000000001111111111111111;
{ Tous les cavaliers. }
  CKnights     = %0100001000000000000000000000000000000000000000000000000001000010;
{ Rois. }
  CKings       = %0001000000000000000000000000000000000000000000000000000000010000;

var
  LBrd: uint64;
  
begin
{ Le roi et les cavaliers blancs. }
  LBrd := CWhitePieces and (CKnights or CKings);
  PrintBoard(LBrd);
end.
