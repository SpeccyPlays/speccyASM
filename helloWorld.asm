  DEVICE ZXSPECTRUM48
  org $8000
  jp start

msg:
    db "Hello world"
MSG_SIZE        = $ - msg ;$ current instruction addrees - size of message
ROM_CLS         = $0DAF
ENTER           = $0D

start:
  im 1
  call ROM_CLS
  ld hl, msg
  ld b, MSG_SIZE
loop:
  ld a,(hl)
  rst $10
  inc hl
  dec b
  jr nz, loop
  ret

  ;Deployment: Snapshot
    SAVESNA "helloWorld.sna", start
