;for vasm assembler, madmac syntax
stacksz = 256   ;stacklsz-stackint is amount of free stack space required for successful work of this routine
stackint = 20   ;stack space reserved for irq and nmi

quicksort:    
           ld (.glb+1),hl
           ld (.gub+1),de
           ld hl,0
           add hl,sp
           ld (.csp+1),hl
           ld de,stacksz-stackint
           sbc hl,de   ;C=0
           ld (.lim+1),hl
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

           ld l,c
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

           ld a,e
           cp l
           jr z,.l2

.l1:       push bc
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
           dec l
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

.qs_l8:    ld c,l
           ld b,h
.lb:       ld hl,0
           xor a
           sbc hl,de
           ld h,b
           ld l,c
           jr nc,.qs_l5

           push hl
           ld hl,(.ub+1)
           push hl
           ld hl,(.lb+1)
           call .qs0
           pop hl
           ld (.ub+1),hl
           pop hl
.qs_l5:    ld de,(.ub+1)
           xor a
           ld b,h
           ld c,l
           sbc hl,de
           ret nc

           ld l,c
           ld h,b
           ld (.lb+1),hl
           call .qs0
           ret

