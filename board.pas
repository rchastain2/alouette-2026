{**
  @abstract(Échiquier binaire.)
  Représentation d'un échiquier par une variable de 64 chiffres binaires.
}
unit Board;

interface

{** Pour savoir si une case est allumée dans un damier. }
function IsOn(const ABrd, ASqr: Int64): boolean;
{** Allume une case dans un damier. }
procedure SwitchOn(var ABrd: Int64; const ASqr: Int64);
{** Éteint une case. }
procedure SwitchOff(var ABrd: Int64; const ASqr: Int64);

{** Affiche un échiquier binaire dans la sortie standard. }
procedure PrintBoard(const ABrd: Int64);

{** Convertit une chaîne de la forme "a1" en un nombre de 0 à 63. }
function DecodeSquareName(const AName: string): integer;

implementation

uses
  SysUtils, Constants;

function IsOn(const ABrd, ASqr: Int64): boolean;
begin
  result := (ABrd and ASqr) = ASqr;
end;

procedure SwitchOn(var ABrd: Int64; const ASqr: Int64);
begin
  ABrd := ABrd or ASqr;
end;

procedure SwitchOff(var ABrd: Int64; const ASqr: Int64);
begin
  ABrd := ABrd and not ASqr;
end;

function BoardToStr(const ABrd: Int64): string;
var
  x, y: integer;
begin
  result := '+   abcdefgh   +' + LineEnding + LineEnding;
  for y := 7 downto 0 do
  begin
    result := result + IntToStr(y + 1) + '   ';
    for x := 0 to 7 do
      result := result + IntToStr(Ord(IsOn(ABrd, CCoordToSquare[x, y])));
    result := result + '   ' + IntToStr(y + 1) + LineEnding;
  end;
  result := result + LineEnding + '+   abcdefgh   +';
end;

procedure PrintBoard(const ABrd: Int64);
begin
  WriteLn(BoardToStr(ABrd));
end;

function DecodeSquareName(const AName: string): integer;
begin
 {Assert((Length(AName) = 2));
  Assert((AName[1] in ['a'..'h']));
  Assert((AName[2] in ['1'..'8']));}
  result := 8 * (Ord(AName[2]) - Ord('1')) + (Ord(AName[1]) - Ord('a'));
end;

end.
