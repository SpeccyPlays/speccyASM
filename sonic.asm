  DEVICE ZXSPECTRUM48
  org $8000

; Rountine
CL_ALL     = $0DAF

; Character codes
ENTER      = $0D
INK        = $10
PAPER      = $11
UDG_0      = $90
UDG_1      = UDG_0+1
UDG_2      = UDG_0+2
UDG_3      = UDG_0+3
UDG_4      = UDG_0+4
UDG_5      = UDG_0+5
UDG_6      = UDG_0+6
UDG_7      = UDG_0+7
UDG_8      = UDG_0+8
UDG_9      = UDG_0+9
UDG_10     = UDG_0+10
UDG_11     = UDG_0+11
STOP       = $E2

udg0_bitmap:
  db %00000111
  db %00011111
  db %00111111
  db %00011111
  db %00001111
  db %00111111
  db %01111111
  db %11111111
udg1_bitmap:
  db %11110000
  db %11111101
  db %11111111
  db %11111111
  db %11111111
  db %11111111
  db %11111111
  db %10001111
udg2_bitmap:
  db %00000000
  db %00000000
  db %00000000
  db %10000000
  db %10000000
  db %10000000
  db %01000000
  db %01000000
udg3_bitmap:
  db %11111111
  db %00011111
  db %00001111
  db %00011111
  db %00011111
  db %00111111
  db %00111111
  db %00110001
udg4_bitmap:
  db %10000110
  db %10001101
  db %10001101
  db %11001101
  db %11100010
  db %11111111
  db %11111111
  db %11111110
udg5_bitmap:
  db %01000000
  db %01000000
  db %01000000
  db %10000000
  db %11000000
  db %11000000
  db %00000000
  db %00000000
udg6_bitmap:
  db %00000011
  db %00000111
  db %00001110
  db %00001100
  db %00000100
  db %00000100
  db %00000011
  db %00000010
udg7_bitmap:
  db %11111100
  db %11111110
  db %01000111
  db %00100110
  db %00100100
  db %01010101
  db %10110111
  db %00100100
udg8_bitmap:
  db %00000000
  db %00000000
  db %00000000
  db %10000000
  db %10000000
  db %10000000
  db %00000000
  db %00000000
udg9_bitmap:
  db %00000011
  db %00000111
  db %00001111
  db %00001111
  db %00000111
  db %00000000
  db %00000000
  db %00000000
udg10_bitmap:
  db %11011111
  db %11011111
  db %11101111
  db %11101111
  db %11111111
  db %00000000
  db %00000000
  db %00000000
udg11_bitmap:
  db %00000000
  db %11000000
  db %11100000
  db %11110000
  db %11110000
  db %00000000
  db %00000000
  db %00000000

SIZE_UDG = $ - udg0_bitmap

sonic:
  db PAPER,7,INK,1,UDG_0,UDG_1,UDG_2,ENTER
  db UDG_3,UDG_4,UDG_5,ENTER
  db UDG_6,UDG_7,UDG_8,ENTER
  db INK,2,UDG_9,UDG_10,UDG_11,ENTER,STOP

UDG_START = $FF58

start:
  im 1
  ei
  call CL_ALL
  ld hl,udg0_bitmap
  ld de,UDG_START
  ld bc,SIZE_UDG
  ldir
  ld hl,sonic
sonicLoop:
  ld a,(hl)
  cp STOP
  jr z,end
  rst $10
  inc hl
  jp sonicLoop
end:
  ret

;Deployment: Snapshot
  SAVESNA "sonic.sna", start
