;for pasmo assembler

;#define sz SIZE
;#define type TYPE
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;void selection() {
;    type *i = data, *k, *min;
;l7: min = i;
;    k = i + 1;
;l3: if (k == data + sz) goto l8;
;    if (*k >= *min) goto l4;
;    min = k;
;l4: k++;
;    goto l3;
;l8: //if (min != i)
;    swap(*min, *i);
;    i++;
;    if (i != k) goto l7;
;}

selsort   ld a,e          ;min - HL, k - DE
          ld (.sz2lo+1),a
          ld a,d
          ld (.sz2hi+1),a
          push hl
.ll7:     ld e,l
          ld d,h
if ESZ=2
          inc e            ;even
endif
          inc de
.ll3:     ld a,e
.sz2lo:   cp 0
          jp nz,.no8

          ld a,d
.sz2hi:   cp 0
          jr z,.ll8
.no8:
          ex de,hl
          ld a,(hl)
          ex de,hl
          cp (hl)
if ESZ=2
          ex de,hl
          inc l
          ld a,(hl)
          dec l
          ex de,hl
          inc l
          sbc a,(hl)
          dec l
endif
          jr nc,.ll4

          ld l,e
          ld h,d
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

