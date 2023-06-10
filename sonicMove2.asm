
	org &8000		;Start of our program

	ld b,&10		;Xpos (in bytes)
	ld c,&10		;Ypos (in pixels)

	push bc
		call GetColMemPos	; Get color address

		ld c,6			;Height
SpriteNextColorLine:
		ld a,%00000011
		ld b,6			;Width
		push de
SpriteNextColorByte:
			ld (de),a	;Color a byte
			inc de
			djnz SpriteNextColorByte
		pop de

		call GetNextColLine		;Move down a ColorMem line

		dec c
		jr nz,SpriteNextColorLine
	pop bc


	call GetScreenPos	;Get Screen Memory pos
	ld hl,TestSprite	;Sprite Source
	ld ixh,48			;Lines

SpriteNextLine:
	ld bc,6				;Bytes per line (Width)
	push de
SpriteNextByte:
		ldir 			;Copy BC bytes from HL to De
	pop de
	call GetNextLine	;Scr Next Line (Alter DE to move down a line)

	dec ixh
	jr nz,SpriteNextLine	;Repeat for next line

	ret					;Finished


TestSprite:
	incbin "\ResALL\Sprites\RawZX.RAW"



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;	_0 _1 _0 Y7 Y6 Y2 Y1 Y0   Y5 Y4 Y3 X4 X3 X2 X1 X0

;	; Input  BC= XY (x=bytes - so 32 across)
;	; output DE= screen mem pos
GetScreenPos:	;return memory pos in DE of screen co-ord B,C (X,Y)
	ld a,c
	and %00111000
	rlca
	rlca
	or b
	ld e,a
	ld a,c
	and %00000111
	ld d,a
	ld a,c
	and %11000000
	rrca
	rrca
	rrca
	or d
	or  &40			;&4000 screen base
	ld d,a
	ret

GetNextLine:			;Move DE down one line
	inc d
	ld a,d
	and   %00000111		;See if we're over the first 3rd
	ret nz
	ld a,e
	add a,%00100000
	ld e,a
	ret c				;See if we're over the 2'nd 3rd
	ld a,d
	sub   %00001000
	ld d,a
	ret


; Input  BC= XY (x=bytes - so 32 across)
; output DE= screen mem pos
GetColMemPos:			;YYYYYyyy 	Color ram is in 8x8 tiles
	ld a,C							;so low three Y bits are ignored
		and %11000000	;YY------
		rlca
		rlca			;------YY
		add &58 		;5800 =color ram base
		ld d,a
	ld a,C
	and %00111000		;--YYY---
	rlca
	rlca				;YYY-----

	add b				;Add Xpos
	ld e,a
	ret

GetNextColLine:			;Move down a color line
	ld a,e
	add 32				;Add 32 to line DE
	ld e,a
	ret nc
	inc d				;Add any carry to DE
	ret
