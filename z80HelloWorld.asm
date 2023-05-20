  DEVICE ZXSPECTRUM48

  org $8000

start:
  ld a,$D6
  ld ($5800),a
  ld ($5800+1),a
  ret

;Deployment: Snapshot
  SAVESNA "z80HelloWorld.sna", start
