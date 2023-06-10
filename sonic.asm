;following the Jonathan Caudwell book
  DEVICE ZXSPECTRUM48
  org $8000
start:
;set screen to be black
  ld a,%00000111         ;white ink on black paper. Bright
  ld (23963),a    ;set our screen colours
  xor a           ;load accumulator with 0
  call 8859       ;set perminant border colours
;set up graphics
  ld hl,sonicStand    ;address of graphics UDG data
  ld (23675),hl   ;make UDGs  point to above
;start the game
  call 3503       ;rom routine ro clear screen and open channel 2

;initise co-ords
  ld hl,16+15*256 ;load hl with starting co-ords
  ld (plx),hl      ;set player co-ords
  call basexy
  call splayr

mloop:

;delete the player
  call basexy     ;set x/y for player
  call wspace     ;wipe player position
;move the player
  ld bc, 63486    ;keyboard row 1-5
  in a,(c)        ;see what's pressed
  rra            ;outer key = bit 1
  push af         ;remember value
  call nc,mpl     ;if pressed move go_left
  pop af          ;restore saved value
  rra             ;bit 2
  push af
  call nc,mpr     ;if pressed move right
  pop af
  rra
  push af
  call nc,mpd
  pop af
  rra
  call nc,mpu

;draw the player
  call basexy
  call splayr
  call wait

;jump back to main loop
  jp mloop

  ; Move player left.
mpl:
  ld hl,ply ; remember, y is the horizontal coord!
  ld a,(hl) ; what's the current value?
  and a ; is it zero?
  ret z ; yes - we can't go any further left.
  dec (hl) ; subtract 1 from y coordinate.
  ret
  ; Move player right.
mpr:
  ld hl,ply ; remember, y is the horizontal coord!
  ld a,(hl) ; what's the current value?
  cp 29 ; is it at the right edge (31)?
  ret z ; yes - we can't go any further left.
  inc (hl) ; add 1 to y coordinate.
  ret
  ; Move player up.
mpu:
  ld hl,plx ; remember, x is the vertical coord!
  ld a,(hl) ; what's the current value?
  cp 4 ; is it at upper limit (4)?
  ret z ; yes - we can go no further then.
  dec (hl) ; subtract 1 from x coordinate.
  ret
  ; Move player down.
mpd:
  ld hl,plx ; remember, x is the vertical coord!
  ld a,(hl) ; what's the current value?
  cp 16 ; is it already at the bottom (21)?
  ret z ; yes - we can't go down any more.
  inc (hl) ; add 1 to x coordinate.
  ret
  ; Set up the x and y coordinates for the player's gunbase position,
  ; this routine is called prior to display and deletion of gunbase.
basexy:
  ld a,22 ; AT code.
  rst 16
  ld a,(plx) ; player vertical coord.
  rst 16 ; set vertical position of player.
  ld a,(ply) ; player's horizontal position.
  rst 16 ; set the horizontal coord.
  ret
  ; Show player at current print position.
splayr:
  ld a,%00111001 ; blue ink white paper bright
  ; bright (64).
  ld (23695),a ; set our temporary screen colours.
  ld a,144 ; ASCII code for User Defined Graphic 'A'.
  rst 16 ; draw player.
  ld a,145
  rst 16
  ld a,146
  rst 16
  ;draw second line
  ld a,22 ; AT code.
  rst 16
  ld a,(plx) ; player vertical coord.
  add a,1
  rst 16 ; set vertical position of player.
  ld a,(ply) ; player's horizontal position.
  rst 16 ; set the horizontal coord.
  ld a,147 ; ASCII code for User Defined Graphic 'A'.
  rst 16 ; draw player.
  ld a,148
  rst 16
  ld a,149
  rst 16
  ;draw third line
  ld a,22 ; AT code.
  rst 16
  ld a,(plx) ; player vertical coord.
  add a,2
  rst 16 ; set vertical position of player.
  ld a,(ply) ; player's horizontal position.
  rst 16
  ld a,150 ; ASCII code for User Defined Graphic 'A'.
  rst 16 ; draw player.
  ld a,151
  rst 16
  ld a,152
  rst 16
  ;draw forth line
  ld a,22 ; AT code.
  rst 16
  ld a,(plx) ; player vertical coord.
  add a,3
  rst 16 ; set vertical position of player.
  ld a,(ply) ; player's horizontal position.
  rst 16
  ld a,153 ; ASCII code for User Defined Graphic 'A'.
  rst 16 ; draw player.
  ld a,154
  rst 16
  ld a,155
  rst 16
  ret
wspace:
  ld a,%00111111 ; white ink (7) on black paper (0),
  ; bright (64).
  ld (23695),a ; set our temporary screen colours.
  ld a,32 ; SPACE character.
  rst 16 ; display space.
  ld a,32 ; SPACE character.
  rst 16 ; display space.
  ld a,32 ; SPACE character.
  rst 16 ; display space.
  ;draw second line
  ld a,22 ; AT code.
  rst 16
  ld a,(plx) ; player vertical coord.
  add a,1
  rst 16 ; set vertical position of player.
  ld a,(ply) ; player's horizontal position.
  rst 16 ; set the horizontal coord.
  ld a,32 ; ASCII code for User Defined Graphic 'A'.
  rst 16 ; draw player.
  ld a,32
  rst 16
  ld a,32
  rst 16
  ;draw third line
  ld a,22 ; AT code.
  rst 16
  ld a,(plx) ; player vertical coord.
  add a,2
  rst 16 ; set vertical position of player.
  ld a,(ply) ; player's horizontal position.
  rst 16
  ld a,32 ; ASCII code for User Defined Graphic 'A'.
  rst 16 ; draw player.
  ld a,32
  rst 16
  ld a,32
  rst 16
  ;draw forth line
  ld a,22 ; AT code.
  rst 16
  ld a,(plx) ; player vertical coord.
  add a,3
  rst 16 ; set vertical position of player.
  ld a,(ply) ; player's horizontal position.
  rst 16
  ld a,32 ; ASCII code for User Defined Graphic 'A'.
  rst 16 ; draw player.
  ld a,32
  rst 16
  ld a,32
  rst 16
  ret
wait:
  ld hl,pretim ; previous time setting
  ld a,(23672) ; current timer setting.
  sub (hl) ; difference between the two.
  cp 2 ; have two frames elapsed yet?
  jr nc,wait0 ; yes, no more delay.
  jp wait
wait0:
  ld a,(23672) ; current timer.
  ld (hl),a ; store this setting.
  ret
pretim defb 0

plx:
  defb 0 ; player's x coordinate.
ply:
  defb 0 ; player's y coordinate.
  ; UDG graphicss
sonicStand:
	DEFB	  7, 24, 32, 16,  8, 48, 64,128
	DEFB	240, 13,  2,  0,  0,  0,112,137
	DEFB	  0,  0,128,128,128,128, 64, 64
	DEFB	224, 16, 12, 16, 16, 32, 47, 49
	DEFB	134,141,141, 77, 34, 28,  1,  2
	DEFB	 64, 64, 64,128,192,192,  0,  0
	DEFB	  2,  5, 10, 12,  4,  4,  3,  2
	DEFB	252,134, 71, 38, 36, 85,183, 36
	DEFB	  0,  0,  0,128,128,128,  0,  0
	DEFB	  2,  4,  8,  8,  7,  0,  0,  0
	DEFB	 35, 32, 16, 16,255,  0,  0,  0
	DEFB	  0,192, 32, 16,240,  0,  0,  0
end:
; Deployment: Snapshot
  SAVETAP "sonic.tap", start
