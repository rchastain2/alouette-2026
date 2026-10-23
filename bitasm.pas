{**
  @abstract(Opérations sur les damiers en assembleur.)
  Versions x86-64 de BitCount et BitScanForward, qui remplacent celles de l'unité Board lorsque le symbole BITASM est défini.
  Requiert un processeur disposant de l'instruction POPCNT.
  L'assembleur interne de Blaise ne connaissant pas les instructions POPCNT, BSF et CMOVNZ, celles-ci sont codées octet par octet.
}

unit BitAsm;

interface

{** Nombre de cases allumées dans un damier. }
function BitCount(const ABrd: Int64): integer;
{** Index de la première case allumée dans un damier, ou -1 si le damier est vide. }
function BitScanForward(const ABrd: Int64): integer;

implementation

function BitCount(const ABrd: Int64): integer; assembler; nostackframe;
asm
  .byte 0xf3, 0x48, 0x0f, 0xb8, 0xc7  # popcnt %rdi, %rax
  ret
end;

function BitScanForward(const ABrd: Int64): integer; assembler; nostackframe;
asm
  movq $-1, %rax
  .byte 0x48, 0x0f, 0xbc, 0xcf        # bsf %rdi, %rcx
  .byte 0x48, 0x0f, 0x45, 0xc1        # cmovnz %rcx, %rax
  ret
end;

end.
