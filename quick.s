;for vasm assembler, madmac syntax
stacklvl = 26   ;stacklvl*6+stackint is amount of free stack space required for successful work of this routine
;stackint = 20   ;stack space should be reserved for irq and nmi, this value isn't used in code

;#include <setjmp.h>
;#define sz 30000
;#define splimit 20
;#define type unsigned short
;#define ssz 200
;#define swap(x,y) {type t = x; x = y; y = t;}
;jmp_buf jmp_point;
;type *sa[ssz], **sp;
;void push(type *d) {
;    *sp-- = d;
;}
;type* pop() {
;    return *++sp;
;}
;type data[sz];
;type x, *ub, *lb, *i2, *j2;
;void quick0() {
;    sp--;
;    if (sp - sa < splimit) longjmp(jmp_point, 1);
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
;    quick0();
;    ub = pop();
;    i2 = pop();
;qs_l5:
;    if (i2 >= ub) goto quit;
;    lb = i2;
;    quick0();
;quit:
;    sp++;
;}
;void quick() {
;    type *gub = ub, *glb = lb;
;    setjmp(jmp_point);
;    sp = sa + ssz - 1;
;    ub = gub;
;    lb = glb;
;    quick0();
;}

quicksort: ld (.glb+1),hl
      if ODD_OFFSET
           ld a,l
           and 1
           jr z,.z

           ld a,$2c   ;inc l
.z:        ld (.evenness),a
      endif
           ld (.gub+1),de
           ld hl,0
           add hl,sp
           ld (.csp+1),hl
           ld de,stacklvl*6
           ex de,hl
           sbc hl,de   ;C=0
           ld (.lim+1),hl
.csp:      ld sp,0
.gub:      ld de,0
.glb:      ld hl,0
.qs0:      ld (.lb+1),hl
.qs1:      ld (.ub+1),de
.lim:      ld hl,0
           add hl,sp
           jr nc,.csp

           ld hl,(.lb+1)
.ub:       ld de,0
           add hl,de
           rr h
           rr l
      if ESZ=2
           srl l
           sla l
      endif
      if ODD_OFFSET
.evenness: nop
      endif
           ld c,(hl)
      if ESZ=2
      if ODD_OFFSET
           inc hl
      else
           inc l
      endif
           ld b,(hl)
      endif
           ld hl,(.lb+1)

.loop1:    ld a,(hl)     ;compare array[i] and x
           cp c
      if ESZ=2
      if ODD_OFFSET
           inc hl
      else
           inc l
      endif
           ld a,(hl)
      if ODD_OFFSET
           dec hl
      else
           dec l
      endif
           sbc a,b
      endif
           jr nc,.qs_l1

      if ODD_OFFSET
           inc hl
      endif
      if ESZ=2
           inc l
      endif
      if ODD_OFFSET==0
           inc hl
      endif
           jp .loop1

.qs_l1:    ex de,hl     ;compare array[j] and x
           ld a,c
           cp (hl)
      if ESZ=2
           ld a,b
      if ODD_OFFSET
           inc hl
      else
           inc l
      endif
           sbc a,(hl)
      if ODD_OFFSET
           dec hl
      else
           dec l
      endif
      endif
           ex de,hl
           jr nc,.qs_l3

      if ODD_OFFSET==0
           dec de
      endif
      if ESZ=2
           dec e
      endif
      if ODD_OFFSET
           dec de
      endif
           jp .qs_l1

.qs_l3:    ld a,e     ;compare i and j
           cp l
           ld a,d
           sbc h
           jr c,.qs_l8
           jr nz,.l1

           ld a,e
           cp l
           jr z,.l2

.l1:       push bc     ;exchange elements with i and j indices
           ld b,(hl)
           ld a,(de)
           ld (hl),a
           ld a,b
           ld (de),a
      if ESZ=2
      if ODD_OFFSET
           inc hl
           inc de
      else
           inc l
           inc e
      endif
           ld b,(hl)
           ld a,(de)
           ld (hl),a
           ld a,b
           ld (de),a
      if ODD_OFFSET
           dec hl
           dec de
      else
           dec l
           dec e
      endif
      endif
           pop bc
.l2:
      if ODD_OFFSET
           inc hl
      else
           dec de
      endif
      if ESZ=2
           dec e
           inc l
      endif
      if ODD_OFFSET==0
           inc hl
      else
           dec de
      endif
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
           call .qs1
           pop hl
           ld (.ub+1),hl
           pop hl
.qs_l5:    ld de,(.ub+1)
           ld a,l
           sub e
           ld a,h
           sbc a,d
           ret nc

           call .qs0  ;don't use the tail call optimization! it can be much slower for some data
           ret

