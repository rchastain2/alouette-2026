
unit BitCountAsm;

{$ASMMODE INTEL}

interface

function BitCount3264(var n: Int64): byte; assembler; inline;
function BitCount64(const n: Int64): Int64; assembler; inline;

implementation

{ https://www.developpez.net/forums/d2001819/autres-langages/assembleur/x86-32-bits-64-bits/reecriture-pascal-d-fonction-assembleur/#post11122922 }

function BitCount3264(var n: Int64): byte; assembler; nostackframe; inline;
asm
  popcnt edx, dword ptr [n]
  popcnt eax, dword ptr [n+4]   
  add    eax, edx                   
end;

{ https://forum.lazarus.freepascal.org/index.php/topic,45840.msg324823.html#msg324823 }

function BitCount64(const n: Int64): Int64; assembler; nostackframe; inline;
asm
  popcnt @result, n
end;

end.
