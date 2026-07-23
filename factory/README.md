# Factory

Programs for code source building. 

## Demo

Generate constant bitboards in INC files.

```
$ make NATIVE=1
[INFO] Compiling columns.pas
/home/roland/apps/blaise/git/compiler/target/blaise --source columns.pas --output columns --unit-path /home/roland/Documents/pascal/echecs/alouette/2026/factory --unit-path /home/roland/apps/blaise/git/stdlib/src/main/pascal --backend native
[INFO] Executing columns
./columns > columns.inc
[INFO] Compiling paths.pas
/home/roland/apps/blaise/git/compiler/target/blaise --source paths.pas --output paths --unit-path /home/roland/Documents/pascal/echecs/alouette/2026/factory --unit-path /home/roland/apps/blaise/git/stdlib/src/main/pascal --backend native
[INFO] Executing paths
./paths > paths.inc
[INFO] Compiling squarenamesarray.pas
/home/roland/apps/blaise/git/compiler/target/blaise --source squarenamesarray.pas --output squarenamesarray --unit-path /home/roland/Documents/pascal/echecs/alouette/2026/factory --unit-path /home/roland/apps/blaise/git/stdlib/src/main/pascal --backend native
[INFO] Executing squarenamesarray
./squarenamesarray > squarenamesarray.inc
[INFO] Compiling squarenames.pas
/home/roland/apps/blaise/git/compiler/target/blaise --source squarenames.pas --output squarenames --unit-path /home/roland/Documents/pascal/echecs/alouette/2026/factory --unit-path /home/roland/apps/blaise/git/stdlib/src/main/pascal --backend native
[INFO] Executing squarenames
./squarenames > squarenames.inc
[INFO] Compiling squaresbycoordinates.pas
/home/roland/apps/blaise/git/compiler/target/blaise --source squaresbycoordinates.pas --output squaresbycoordinates --unit-path /home/roland/Documents/pascal/echecs/alouette/2026/factory --unit-path /home/roland/apps/blaise/git/stdlib/src/main/pascal --backend native
[INFO] Executing squaresbycoordinates
./squaresbycoordinates > squaresbycoordinates.inc
[INFO] Compiling squaresbyindex.pas
/home/roland/apps/blaise/git/compiler/target/blaise --source squaresbyindex.pas --output squaresbyindex --unit-path /home/roland/Documents/pascal/echecs/alouette/2026/factory --unit-path /home/roland/apps/blaise/git/stdlib/src/main/pascal --backend native
[INFO] Executing squaresbyindex
./squaresbyindex > squaresbyindex.inc
[INFO] Compiling targets.pas
/home/roland/apps/blaise/git/compiler/target/blaise --source targets.pas --output targets --unit-path /home/roland/Documents/pascal/echecs/alouette/2026/factory --unit-path /home/roland/apps/blaise/git/stdlib/src/main/pascal --backend native
[INFO] Executing targets
./targets > targets.inc
[INFO] Compiling whitesquares.pas
/home/roland/apps/blaise/git/compiler/target/blaise --source whitesquares.pas --output whitesquares --unit-path /home/roland/Documents/pascal/echecs/alouette/2026/factory --unit-path /home/roland/apps/blaise/git/stdlib/src/main/pascal --backend native
[INFO] Executing whitesquares
./whitesquares > whitesquares.inc
```

Create unit *constants.pas*.

```bash
sh preprocess.sh
```

```pascal
unit Constants;

interface

uses
  ChessTypes;

const
  CWhiteSquares: Int64 = $55AA55AA55AA55AA;
  
  CColumns: array[0..7] of Int64 = (
    $0101010101010101,
    $0202020202020202,
    $0404040404040404,
    $0808080808080808,
    $1010101010101010,
    $2020202020202020,
    $4040404040404040,
    $0000000000000000
  );
  
  CSquareNames: array[A1..H8] of string = (
    'a1', 'b1', 'c1', 'd1', 'e1', 'f1', 'g1', 'h1',
    'a2', 'b2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2',
    'a3', 'b3', 'c3', 'd3', 'e3', 'f3', 'g3', 'h3',
    'a4', 'b4', 'c4', 'd4', 'e4', 'f4', 'g4', 'h4',
    'a5', 'b5', 'c5', 'd5', 'e5', 'f5', 'g5', 'h5',
    'a6', 'b6', 'c6', 'd6', 'e6', 'f6', 'g6', 'h6',
    'a7', 'b7', 'c7', 'd7', 'e7', 'f7', 'g7', 'h7',
    'a8', 'b8', 'c8', 'd8', 'e8', 'f8', 'g8', 'h8'
  );
  
  CIndexToSquare: array[A1..H8] of Int64 = (
    $0000000000000001, $0000000000000002, $0000000000000004, $0000000000000008, $0000000000000010, $0000000000000020, $0000000000000040, $0000000000000080,
    $0000000000000100, $0000000000000200, $0000000000000400, $0000000000000800, $0000000000001000, $0000000000002000, $0000000000004000, $0000000000008000,
    $0000000000010000, $0000000000020000, $0000000000040000, $0000000000080000, $0000000000100000, $0000000000200000, $0000000000400000, $0000000000800000,
    $0000000001000000, $0000000002000000, $0000000004000000, $0000000008000000, $0000000010000000, $0000000020000000, $0000000040000000, $0000000080000000,
    $0000000100000000, $0000000200000000, $0000000400000000, $0000000800000000, $0000001000000000, $0000002000000000, $0000004000000000, $0000008000000000,
    $0000010000000000, $0000020000000000, $0000040000000000, $0000080000000000, $0000100000000000, $0000200000000000, $0000400000000000, $0000800000000000,
    $0001000000000000, $0002000000000000, $0004000000000000, $0008000000000000, $0010000000000000, $0020000000000000, $0040000000000000, $0080000000000000,
    $0100000000000000, $0200000000000000, $0400000000000000, $0800000000000000, $1000000000000000, $2000000000000000, $4000000000000000, $0000000000000000
  );
  
  CCoordToSquare: array[0..7, 0..7] of Int64 = (
    ($0000000000000001, $0000000000000100, $0000000000010000, $0000000001000000, $0000000100000000, $0000010000000000, $0001000000000000, $0100000000000000),
    ($0000000000000002, $0000000000000200, $0000000000020000, $0000000002000000, $0000000200000000, $0000020000000000, $0002000000000000, $0200000000000000),
    ($0000000000000004, $0000000000000400, $0000000000040000, $0000000004000000, $0000000400000000, $0000040000000000, $0004000000000000, $0400000000000000),
    ($0000000000000008, $0000000000000800, $0000000000080000, $0000000008000000, $0000000800000000, $0000080000000000, $0008000000000000, $0800000000000000),
    ($0000000000000010, $0000000000001000, $0000000000100000, $0000000010000000, $0000001000000000, $0000100000000000, $0010000000000000, $1000000000000000),
    ($0000000000000020, $0000000000002000, $0000000000200000, $0000000020000000, $0000002000000000, $0000200000000000, $0020000000000000, $2000000000000000),
    ($0000000000000040, $0000000000004000, $0000000000400000, $0000000040000000, $0000004000000000, $0000400000000000, $0040000000000000, $4000000000000000),
    ($0000000000000080, $0000000000008000, $0000000000800000, $0000000080000000, $0000008000000000, $0000800000000000, $0080000000000000, $0000000000000000)
  );
  
  CTargets: array[TPieceType, A1..H8] of Int64 = (
    (
      $0000000000000200, $0000000000000500, $0000000000000A00, $0000000000001400, $0000000000002800, $0000000000005000, $000000000000A000, $0000000000004000,
      $0000000000020000, $0000000000050000, $00000000000A0000, $0000000000140000, $0000000000280000, $0000000000500000, $0000000000A00000, $0000000000400000,
      $0000000002000000, $0000000005000000, $000000000A000000, $0000000014000000, $0000000028000000, $0000000050000000, $00000000A0000000, $0000000040000000,
      $0000000200000000, $0000000500000000, $0000000A00000000, $0000001400000000, $0000002800000000, $0000005000000000, $000000A000000000, $0000004000000000,
      $0000020000000000, $0000050000000000, $00000A0000000000, $0000140000000000, $0000280000000000, $0000500000000000, $0000A00000000000, $0000400000000000,
      $0002000000000000, $0005000000000000, $000A000000000000, $0014000000000000, $0028000000000000, $0050000000000000, $00A0000000000000, $0040000000000000,
      $0200000000000000, $0500000000000000, $0A00000000000000, $1400000000000000, $2800000000000000, $5000000000000000, $0000000000000000, $4000000000000000,
      $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000
    ),
```

Go to *tutorial* directory and build a demo program.

```
$ cd ../tutorial && make boarddemo5 NATIVE=1

$ ./boarddemo5
+   abcdefgh   +

8   01000001   8
7   01000000   7
6   01000000   6
5   01000000   5
4   01000000   4
3   01000000   3
2   10111111   2
1   01000000   1

+   abcdefgh   + 
```
