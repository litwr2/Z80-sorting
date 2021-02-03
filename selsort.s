;for pasmo assembler

selsort
;.i2lo = 10  ;zero page locations, select any available on your system
;.i2hi = .i2lo+1
;.k2lo = 12
;.k2hi = .k2lo+1
;.minlo = 14
;.minhi = .minlo+1

          ld a,e
          ld (.sz2lo+1),a
          ld a,d
          ld (.sz2hi+1),a
          ld (.i2),hl
.ll7:     ;ld hl,(.i2)
          ld e,l
          ld d,h
if ESZ=2
          inc e            ;even
endif
          inc de
.ll3:     ld a,d
.sz2hi:   cp 0
          jp nz,.no8

          ld a,e
.sz2lo:   cp 0
          jp z,.ll8

.no8:     ld a,(hl)
          ex de,hl
          cp (hl)
          ex de,hl
if ESZ=2
          inc l
          ld a,(hl)
          dec l
          ex de,hl
          inc l
          sbc a,(hl)
          dec l
          ex de,hl
endif
          jp c,.ll4

          ex de,hl
.ll4:
if ESZ=2
          inc e            ;even
endif
          inc de
          jp .ll3

.ll8:
if ESZ=1
          push hl
          ld b,(hl)
          ld hl,(.i2)
          ld a,(hl)
          ld (hl),b
          inc hl
          ld b,h
          ld c,l
          pop hl
          ld (hl),a
          ld h,b
          ld l,c
else
          ld (.m1a+1),hl
          ld (.m1b+1),hl
          ld hl,(.i2)
          push hl
          ld (.m2a+1),hl
          ld (.m2b+1),hl
.m1a      ld hl,(0)
          push hl
.m2a      ld hl,(0)
.m1b      ld (0),hl
          pop hl
.m2b      ld (0),hl
          pop hl
          inc l
          inc hl
endif
          ld (.i2),hl
          ld a,l
          cp e
          jp nz,.ll7

          ld a,h
          cp d
          jp nz,.ll7
          ret
          
.i2 dw 0

