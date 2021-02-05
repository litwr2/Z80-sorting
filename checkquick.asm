ESZ = 1      ;an element size
data = $300  ;sorted array must start here, it must be word aligned if ESZ=2
sz = 1000   ;number of elements in the array

     org $100
        ld hl,data
        ld de,data+(sz-1)*ESZ
        call quicksort     ;C=0 means fail
        ;jr c,*+2
        halt               ;stop here

     org $200
     include "quick.s"

