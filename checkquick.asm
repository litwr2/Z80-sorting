ESZ = 1      ;an element size
data = $400  ;sorted array must start here, it must be word aligned if ESZ=2
sz = 60000   ;number of elements in the array

ODD_OFFSET = (data & 1) && ESZ=2  ;1 makes code larger and slower

     org $100
        ld hl,data
        ld de,data+(sz-1)*ESZ
        call quicksort     ;C=1 means fail
        halt               ;stop here

     ;include "quick.s"
     include "quick-nr.s"

