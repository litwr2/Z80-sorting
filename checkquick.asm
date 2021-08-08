ESZ = 2      ;an element size
data = $300  ;sorted array must start here, it must be word aligned if ESZ=2
sz = 30000   ;number of elements in the array

     org $100
        ld hl,data
        ld de,data+(sz-1)*ESZ
        call quicksort     ;C=1 means fail
        jr c,$+2
        halt               ;stop here

     include "quick.s"
     ;include "quick-nr.s"

