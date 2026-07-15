
{ https://www.developpez.net/forums/d2001819-2/autres-langages/assembleur/x86-32-bits-64-bits/reecriture-pascal-d-fonction-assembleur/#post11124482 }

function BitCount(X: Int64): Byte;
begin
   X := (X and $5555555555555555) + ((X shr  1) and $5555555555555555);
   X := (X and $3333333333333333) + ((X shr  2) and $3333333333333333);
   X := (X and $0F0F0F0F0F0F0F0F) + ((X shr  4) and $0F0F0F0F0F0F0F0F);
   X := (X and $00FF00FF00FF00FF) + ((X shr  8) and $00FF00FF00FF00FF);
   X := (X and $0000FFFF0000FFFF) + ((X shr 16) and $0000FFFF0000FFFF);
   X := (X and $00000000FFFFFFFF) + ((X shr 32) and $00000000FFFFFFFF);
  result := Byte(X);
end;
 
function BitScanForward(X : Int64): Integer;
var Y : int64;
begin
   if X = 0 then Exit(-1);
   result := 0;
   Y := X and $00000000FFFFFFFF; if Y = 0 then result += 32 else X := Y;
   Y := X and $0000FFFF0000FFFF; if Y = 0 then result += 16 else X := Y;
   Y := X and $00FF00FF00FF00FF; if Y = 0 then result +=  8 else X := Y;
   Y := X and $0F0F0F0F0F0F0F0F; if Y = 0 then result +=  4 else X := Y;
   Y := X and $3333333333333333; if Y = 0 then result +=  2 else X := Y;
   if X and $5555555555555555 = 0 then result +=  1;
end;
 
function BitScanReverse(X: Int64): Integer;
var Y : int64;
begin
   if X = 0 then Exit(-1);
   result := 63;
   Y := X and $FFFFFFFF00000000; if Y = 0 then result -= 32 else X := Y;
   Y := X and $FFFF0000FFFF0000; if Y = 0 then result -= 16 else X := Y;
   Y := X and $FF00FF00FF00FF00; if Y = 0 then result -=  8 else X := Y;
   Y := X and $F0F0F0F0F0F0F0F0; if Y = 0 then result -=  4 else X := Y;
   Y := X and $CCCCCCCCCCCCCCCC; if Y = 0 then result -=  2 else X := Y;
   if   X and $AAAAAAAAAAAAAAAA = 0 then result -= 1;
end;
