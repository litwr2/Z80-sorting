ESZ = 2        ;the element size
data = $300    ;sorted array must start here
sz = 1000     ;number of elements in the array

        org $100
        ld hl,data
        ld de,data+sz*ESZ
        call selsort
        halt               ;stop here

        org $200
        include "selsort.s"

