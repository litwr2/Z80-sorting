;for vasm assembler, madmac syntax
stacklvl = 26   ;stacklvl*6+stackint is amount of free stack space required for successful work of this routine
stackint = 10   ;stack space reserved for irq and nmi

quicksort:    
           ld (.lb),hl
           ex de,hl
           ld (.ub),hl
.qsok:
           ld hl,(.lb)
           push hl
           ld de,(.ub)
           add hl,de
           srl h
           rr l
           ;srl l
           ;sla l
           ld c,(hl)
           ;inc l
           ;ld b,(hl)
           pop hl
.loop1:
           ld a,(hl)
           cp c
           jr nc,.qs_l1

           inc hl
           jp .loop1
.qs_l1:
           ex de,hl
           ld a,c
           cp (hl)
           ex de,hl
           jr nc,.qs_l3

           dec de
           jp .qs_l1
.qs_l3:
           ld a,e
           cp l
           ld a,d
           sbc h
           jr c,.qs_l8
           jr nz,.l1

           ld a,e
           cp l
           jp z,.l2
.l1:
           ld b,(hl)
           ex de,hl
           ld a,(hl)
           ld (hl),b
           ex de,hl
           ld (hl),a
.l2:
           inc hl
           dec de
           ld a,e
           cp l
           ld a,d
           sbc h
           jp nc,.loop1
.qs_l8:
           push hl
           ld hl,(.lb)
           xor a
           sbc hl,de
           pop hl
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
           ld bc,(.ub)
           xor a
           push hl
           sbc hl,bc
           pop hl
           ret nc

           ld (.lb),hl
           jp .qsok

.lb: dc.w 0
.ub: dc.w 0
