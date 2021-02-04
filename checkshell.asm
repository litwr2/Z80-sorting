ESZ = 2      ;the element size
shelltabidx = 7  ;the default index to the gap table, the first index is equal to 1
                  ;for the best speed, the indexed value should be maximal but close to sz/2
                  ;it is safe to always set it to the max value 11
data = $300  ;sorted array must start here, it must be word aligned if ESZ=2
sz = 1000   ;number of elements in the array

        org $100
        ld a,shelltabidx*2
        ld hl,data
        ld de,data+sz*ESZ
        call shellsort
        halt               ;stop here

        org $200
        include "shell.s"
