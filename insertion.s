;for vasm assembler, madmac syntax

;#define sz SIZE
;#define type TYPE
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;void insertion() {
;    type *i = data + 1, *j, *k;
;l1: if (i >= data + sz) return;
;    j = i;
;l3: k = j - 1;
;    if (j == data || *k <= *j) goto l2;
;    swap(*k, *j);
;    j--;
;    goto l3;
;l2: i++;
;    goto l1;
;}

insertion:
          ld a,e
          ld (.sz2lo+1),a
          ld a,d
          ld (.sz2hi+1),a
          ld a,l
          ld (.datalo+1),a
          ld a,h
          ld (.datahi+1),a
if ESZ=2
          inc l
endif
          inc hl        ;j - HL, k - DE
.ll1:     ld a,l
.sz2lo:   cp 0
          ld a,h
.sz2hi:   sbc a,0
          ret nc

          push hl
.ll3:     ld e,l
          ld d,h
          dec de
if ESZ=2
          dec e
endif
          ld a,l
.datalo:  cp 0
          jr nz,.no2

          ld a,h
.datahi:  cp 0
          jr z,.ll2

.no2:     ld a,(hl)
          ex de,hl
          cp (hl)
if ESZ=2
          ex de,hl
          inc l
          ld a,(hl)
          ex de,hl
          inc l
          sbc a,(hl)
endif
          ex de,hl
          jr nc,.ll2

          ld b,(hl)
          ld a,(de)
          ld (hl),a
          ld a,b          
          ld (de),a
if ESZ=2
          dec e
          dec l
          ld b,(hl)
          ld a,(de)
          ld (hl),a
          ld a,b         
          ld (de),a
endif
          dec hl
if ESZ=2
          dec l
endif
          jp .ll3

.ll2:     pop hl
if ESZ=2
          inc l
endif
          inc hl
          jp .ll1

