
unit Board;

interface

function ToBoard(const AIdx: integer): uint64; overload;
function ToBoard(const ACol, ARow: integer): uint64; overload;
procedure PrintBoard(const ABrd: uint64);

implementation

function ToBoard(const AIdx: integer): uint64;
begin
  result := uint64(1) shl AIdx;
end;

function ToBoard(const ACol, ARow: integer): uint64;
begin
  result := ToBoard(8 * ARow + ACol);
end;

function ToIndex(const ACol, ARow: integer): integer;
begin
  result := 8 * ARow + ACol;
end;

function IsOn(const ABrd, ASqr: uint64): boolean;
begin
  result := (ABrd and ASqr) = ASqr;
end;

function BoardToPrettyStr(const ABrd: uint64): string;
var
  x, y: integer;
begin
  result := '+   abcdefgh   +' + LineEnding + LineEnding;
  for y := 7 downto 0 do
  begin
    result := result + IntToStr(y + 1) + '   ';
    for x := 0 to 7 do
      result := result + IntToStr(Ord(IsOn(ABrd, ToBoard(x, y))));
    result := result + '   ' + IntToStr(y + 1) + LineEnding;
  end;
  result := result + LineEnding + '+   abcdefgh   +';
end;

procedure PrintBoard(const ABrd: uint64);
begin
  WriteLn(BoardToPrettyStr(ABrd));
end;

end.
