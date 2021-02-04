ESZ = 2        ;the element size
data = $300    ;sorted array must start here, it must be word aligned if ESZ=2
sz = 1000      ;number of elements in the array

        org $100
        ld hl,data
        ld de,data+sz*ESZ
        call insertion
        halt              ;stop here

        org $200
        include "insertion.s"

