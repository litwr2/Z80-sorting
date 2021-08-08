;for vasm assembler, madmac syntax
;no recursion variant, it uses 1/3 less stack space
stacklvl = 26   ;stacklvl*4+stackint is amount of free stack space required for successful work of this routine
stackint = 20   ;stack space reserved for irq and nmi

;#define sz 30000
;#define splimit 20
;#define type unsigned short
;#define ssz 200
;#define swap(x,y) {type t = x; x = y; y = t;}
;type *sa[ssz], **sp = sa + ssz;
;void push(type *d) {
;    *--sp = d;
;}
;type* pop() {
;    return *sp++;
;}
;type data[sz];
;type x, *ub, *lb, *i2, *j2;
;type *glb = data, *gub = data + sz - 1;
;void quick0() {
;LOOP:
;    if (sp != sa) goto OK;
;    lb = glb;
;    ub = gub;
;    sp = sa + ssz;
;OK:
;    i2 = lb;
;    j2 = ub;
;    x = *(type*)(((unsigned long)j2 + (unsigned long)i2) >> 1 & ~(sizeof(type) - 1));
;qsloop1:
;    if (*i2 >= x) goto qs_l1;
;    i2 += 1;
;    goto qsloop1;
;qs_l1:
;    if (x >= *j2) goto qs_l3;
;    j2 -= 1;
;    goto qs_l1;
;qs_l3:
;    if (j2 < i2) goto qs_l8;
;    if (j2 != i2) swap(*i2, *j2);
;    i2 += 1;
;    j2 -= 1;
;    if (j2 >= i2) goto qsloop1;
;qs_l8:
;    if (lb >= j2) goto qs_l5;
;    push(i2);
;    push(ub);
;    ub = j2;
;    goto LOOP;
;qs_l5:
;    if (i2 >= ub) goto qs_l7;
;    push(lb);
;    push(j2);
;    lb = i2;
;    goto LOOP;
;qs_l7:
;    if (sp == sa + ssz) return;
;    ub = pop();
;    lb = pop();
;    goto OK;
;}
;void quick() {
;    ub = gub;
;    lb = glb;
;    quick0();
;}

quicksort:
           ld (.glb+1),hl
           ld (.gub+1),de
           ld (.csp+1),sp
           ld (.inix+1),sp
           ld de,stacklvl*4
           sbc hl,de   ;C=0  ??
           ret c

           ld (.lim+1),hl
           ld de,stackint
           sbc hl,de   ;C=0
           ret c

.csp:      ld sp,0
.gub:      ld de,0
.glb:      ld hl,0
.qs0:      ld (.lb+1),hl
           ld (.ub+1),de
           ld b,h
           ld c,l
           ld hl,0
           add hl,sp
.lim:      ld de,0
           sbc hl,de   ;C=0
           jr c,.csp

.qs1:      ld l,c
           ld h,b
           push hl
.ub:       ld de,0
           add hl,de
           rr h
           rr l
if ESZ=2
           srl l
           sla l
endif
           ld c,(hl)
if ESZ=2
           inc l
           ld b,(hl)
endif
           pop hl

.loop1:    ld a,(hl)
           cp c
if ESZ=2
           inc l
           ld a,(hl)
           dec l
           sbc a,b
endif
           jr nc,.qs_l1

if ESZ=2
           inc l
endif
           inc hl
           jp .loop1

.qs_l1:    ex de,hl
           ld a,c
           cp (hl)
if ESZ=2
           ld a,b
           inc l
           sbc a,(hl)
           dec l
endif
           ex de,hl
           jr nc,.qs_l3

           dec de
if ESZ=2
           dec e
endif
           jp .qs_l1

.qs_l3:    ld a,e
           cp l
           ld a,d
           sbc h
           jr c,.qs_l8
           jr nz,.l1

           ld a,e    ;?  - always do swaps
           cp l
           jr z,.l2

.l1:       push bc
           ld b,(hl)
           ld a,(de)
           ld (hl),a
           ld a,b
           ld (de),a
if ESZ=2
           inc l
           ld b,(hl)
           inc e
           ld a,(de)
           ld (hl),a
           dec l
           ld a,b
           ld (de),a
           dec e
endif
           pop bc
.l2:       dec de
if ESZ=2
           dec e
           inc l
endif
           inc hl
           ld a,e
           cp l
           ld a,d
           sbc h
           jp nc,.loop1

.qs_l8:    
.lb:       ld bc,0
           ld a,c
           sub e
           ld a,b
           sbc a,d
           jr nc,.qs_l5

           push hl
           ld hl,(.ub+1)
           push hl
           ld hl,(.lb+1)
           jp .qs0

.qs_l5:    ld bc,(.ub+1)   ;i - hl , j - de
           ld a,l
           sub c
           ld a,h
           sbc a,b
           jr nc,.qs_l7

           ld bc,(.lb+1)
           push bc
           push de     ;don't remove these pushes, they actually make things faster
           ld de,(.ub+1)
           jp .qs0

.qs_l7:    ld hl,0
           add hl,sp
.inix:     ld de,0
           ld a,l
           sub e
           ld e,a
           ld a,h
           sbc a,d
           or e
           ret z

           pop de
           pop hl
           jp .qs0

