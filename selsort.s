;for pasmo assembler

selsort   ld a,e
          ld (.sz2lo+1),a
          ld a,d
          ld (.sz2hi+1),a
          push hl
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

.ll8:     ld b,(hl)
if ESZ=1
          ex (sp),hl
          ld a,(hl)
          ld (hl),b
          inc hl
          ex (sp),hl
          ld (hl),a
          pop hl
else
          inc l
          ld c,(hl)
          ex (sp),hl
          ld a,(hl)
          ld (hl),b
          inc l
          ld b,(hl)
          ld (hl),c
          ex (sp),hl
          ld (hl),b
          dec l
          ld (hl),a
          pop hl
          inc hl
endif
          push hl
          ld a,l
          cp e
          jp nz,.ll7

          ld a,h
          cp d
          jp nz,.ll7

          pop hl
          ret

