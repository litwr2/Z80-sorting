ESZ = 1       ;do not change this value!
data = $400   ;sorted array must start here
auxtable = $200  ;address of the auxilary 512 byte array, it must be word aligned
sz = 60000    ;number of elements in the array

        org $100
        ld b,>auxtable
        ld hl,data
        ld de,data+sz
        call radix8
        halt               ;stop here

        include "radix8.s"

