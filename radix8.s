;for vasm assembler, madmac syntax

;#define sz SIZE
;type data[sz];
;void radix8(uint8_t *a) {
;    for (int i = 0; i < 256; i++) c[i] = 0;
;    for (int j = 0; j < sz; j++)
;        c[a[j]]++;
;    int j = 0;
;    for (int i = 0; i < 256; i++)
;        for (int k = 0; k < c[i]; k++)
;            a[j++] = i;
;}

radix8:  ld a,e
         ld (.szlo+1),a
         ld a,d
         ld (.szhi+1),a
         ld (.data2+1),hl
         ld (.data1+1),hl
         ld a,b
         ld (.chi1+1),a
         ld (.chi2+1),a
         add a,2
         ld (.cne1+1),a
         ld h,b
         ld l,0
.loop1:  xor a
         ld (hl),a
         inc l
         ld (hl),a
         inc hl
         ld a,h
.cne1:   cp 0
         jp nz,.loop1

.data1:  ld hl,0
.loop3:  ld d,h
         ld e,l
         ld l,(hl)
.chi2:   ld h,0
         inc (hl)
         jr nz,.l1

         inc h
         inc (hl)
.l1:     ld h,d
         ld l,e
         inc hl
         ld a,l
.szlo:   cp 0
         jp nz,.loop3

         ld a,h
.szhi:   cp 0
         jp nz,.loop3

.data2:  ld hl,0   ;->a[j]
         xor a,a   ;i
.loop2:  ld bc,0   ;k
         ld e,a
.chi1:   ld d,0
         ld iyl,a
.loop4:  ex de,hl
         ld a,c
         cp (hl)
         inc h
         ld a,b
         sbc a,(hl)
         dec h
         inc bc
         ex de,hl
         ld a,iyl
         jp nc,.l2

         ld (hl),a
         inc hl
         jp .loop4

.l2:     inc a
         jp nz,.loop2
         ret

