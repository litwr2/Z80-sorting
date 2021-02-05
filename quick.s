;for vasm assembler, madmac syntax
stacklvl = 26   ;stacklvl*6+stackint is amount of free stack space required for successful work of this routine
stackint = 10   ;stack space reserved for irq and nmi

quicksort:    
           ld (.lb),hl
           ex de,hl
           ld (.ub),hl
           ex de,hl
.qsok:
           push hl
           ld de,(.ub)
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
.qs_l8:
           ld c,l
           ld b,h
           ld hl,(.lb)
           xor a
           sbc hl,de
           ld h,b
           ld l,c
           jr nc,.qs_l5

           xor a
           ld bc,(.ub)
           push hl
           sbc hl,bc
           pop hl
           jr nc,.l3

           push hl
           ld hl,(.ub)
           push hl
           ld hl,(.lb)
           call quicksort
           pop hl
           ld (.ub),hl
           pop hl
           ld (.lb),hl
           jp .qsok
.l3:
           ld hl,(.lb)
           call quicksort   ;don't use the tail call optimization! it can be much slower for some data
           ret
.qs_l5:
           ld de,(.ub)
           xor a
           ld b,h
           ld c,l
           sbc hl,de
           ret nc

           ld l,c
           ld h,b
           ld (.lb),hl
           jp .qsok

.lb: dc.w 0
.ub: dc.w 0

