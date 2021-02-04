data = $500   ;sorted array must start here, it must be word aligned
auxtable = $300  ;address of the auxilary 512 byte array
sz = 60000    ;number of elements in the array

        org $100
        ld b,>auxtable
        ld hl,data
        ld de,data+sz
        call radix8
        halt               ;stop here

        org $200
        include "radix8.s"

