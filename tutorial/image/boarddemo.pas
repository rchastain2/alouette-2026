
program AggEx;

uses
  SysUtils,
  AggExample,
  agg_2D,
  agg_basics,
  Board,
  Constants;

type
  TAggExample1 = class(TAggExample)
  protected
    procedure Draw(agg: Agg2D_ptr); override;
  end;

procedure TAggExample1.Draw(agg: Agg2D_ptr);
const
  CFont = '/home/roland/Documents/ressources/polices/inconsolata/static/Inconsolata_SemiExpanded-Bold.ttf';
  Letters = 'ABCDEFGH';
  Numbers = '12345678';
var
  c1, c2: Color;
  x, y: integer;  
begin
  c1.Construct($E0, $E0, $E0);
  c2.Construct($D0, $D0, $D0);
  agg^.clearAll($FF, $FF, $FF);
  agg^.noLine;
  
  for x := 0 to 7 do
    for y := 0 to 7 do
    begin
      if IsOn(CWhiteSquares, CCoordToSquare[x, y]) then
        agg^.fillColor(c1)
      else
        agg^.fillColor(c2);
      agg^.rectangle(40 * (x + 1), 40 * (y + 1), 40 * (x + 2), 40 * (y + 2));
    end;
  
  agg^.Font(CFont, 18, false, false, VectorFontCache, 0);
  agg^.textAlignment(AlignCenter, AlignCenter);
  agg^.fillColor(0, 0, 0);
  
  for x := 0 to 7 do
    agg^.Text(40 * (x + 1.5), 20, Letters[x + 1]);
  for y := 0 to 7 do
    agg^.Text(20, 40 * (y + 1.5), Numbers[y + 1]);
end;

var
  p: TAggExample1;
  
begin
  p := TAggExample1.Create(400, 400, ChangeFileExt({$I %FILE%}, '.png'));
  p.DrawImage;
  p.SaveToPng;
  p.Free;
end.
