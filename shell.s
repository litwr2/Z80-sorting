;for vasm assembler, madmac syntax

;#define sz SIZE
;#define type TYPE
;#define tabsz 11
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;unsigned short gap2table[tabsz] = {1, 4, 10, 23, 57, 132, 301, 701, 1750, 4759, 12923, 30001};
;void shell() {
;    type *j2, *i2, *stack;
;    unsigned short gap2;
;    unsigned char x = tabsz;
;lss1:
;    if (x == 0) return;
;    j2 = data;
;    gap2 = gap2table[x - 1];
;    i2 = data + gap2;
;lss3:
;    if (i2 >= data + sz) {
;       x--;
;       goto lss1;
;    }
;    stack = j2;
;lss8:
;    if (*i2 < *j2) {
;        swap(*j2, *i2);
;        i2 = j2;
;        if (j2 - gap2 >= data) {
;            j2 -= gap2;
;            goto lss8;
;        }
;    }
;    j2 = stack + 1;
;    i2 = j2 + gap2;
;    goto lss3;
;}

shellsort:
          ld (.tabsz),a   ;x
          ld (.data+1),hl
          ld a,l
          ld (.datalo+1),a
          ld a,h
          ld (.datahi+1),a
          ld a,e
          ld (.szlo+1),a
          ld a,d
          ld (.szhi+1),a
.lss1:    ld a,(.tabsz)
          or a
          ret m

          ld hl,.gaptable
          add a,l
          ld l,a
          ld a,h
          adc 0
          ld h,a
          ld a,(hl)
          inc hl       ;optimize?  inc l if .gaptable2 doesn't break page border
          ld h,(hl)
          ld l,a
          ld (.gap21+1),hl
          ld (.gap22+1),hl
          ld (.gap23+1),hl
.data:    ld hl,0
          ld d,h       ;j2
          ld e,l
.gap21:   ld bc,0
          add hl,bc    ;i2
.lss3:    ld a,l
.szlo:    cp 0
          ld a,h
.szhi:    sbc a,0
          jp c,.l1

          ld a,(.tabsz)
          sub a,2
          ld (.tabsz),a
          jp .lss1

.l1:      push de
.lss8:    ld a,(hl)
          ex de,hl
          cp (hl)
          ex de,hl
if ESZ=2
          inc l
          ld a,(hl)
          ex de,hl
          inc l
          sbc (hl)
          dec l
          ex de,hl
          dec l
endif
          jr nc,.l2

          ld b,(hl)
          ex de,hl
          ld a,(hl)
          ld (hl),b
          ex de,hl
          ld (hl),a
if ESZ=2
          inc l
          ld b,(hl)
          ex de,hl
          inc l
          ld a,(hl)
          ld (hl),b
          dec l
          ex de,hl
          ld (hl),a
endif
          ld h,d
          ld l,e
          xor a,a
.gap22:   ld bc,0
          sbc hl,bc
          jr c,.l2

          ld b,h
          ld c,l
          ex de,hl
          ld a,c
.datalo:  cp 0
          ld a,b
.datahi:  sbc a,0
          jr c,.l2

          ld d,b
          ld e,c
          jp .lss8

.l2:      pop de
if ESZ=2
          inc e
endif
          inc de
          ld l,e
          ld h,d
.gap23:   ld bc,0
          add hl,bc
          jp .lss3

.tabsz: dc.b 0
.gaptable: dc.w 1*ESZ, 4*ESZ, 10*ESZ, 23*ESZ, 57*ESZ, 132*ESZ, 301*ESZ, 701*ESZ, 1750*ESZ, 4759*ESZ, 12923*ESZ
;    if ESZ==1
;     dc.w 33001*ESZ
;    endif


