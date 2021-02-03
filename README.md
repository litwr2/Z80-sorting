# Z80-sorting
implementations of various sorting algos for the Z80

For each sorting routine the next information is provided:  its size, whether it uses stack or not, required amount of additional memory, the size of code for its call.  All sizes are in bytes.  Benchmark results are clock cycles.  One clock cycle is equal to one millionth of a second for the Z80 at 1 MHz.

Quicksort depends on its *stacklvl* parameter, it must be more than binary logarithm of the number of elements in the sorted array.  The value 26 is used as its default value. 

Shellsort depends on its *shelltabidx* parameter which is used in a normal Shellsort invocation.  For the benchmarks, the value 7 has been used for 1000 element arrays, and the value 11 has been used for 30000 and 60000 element arrays.
Various kinds of filling have been used for testing and benchmarking:
  * *random-1* &ndash; every byte is generated randomly by the standard C random number generator function, numbers in range 0 and 255 are generated;
  * *random-2* &ndash; every byte is generated randomly by a quick and simple homebrew random number generator, numbers in range 0 and 255 are generated;
  * *2-values* &ndash; every byte is generated randomly by the standard C random number generator function, only numbers 0 and 1 are generated;
  * *4-values* &ndash; every 16-bit word is generated randomly by the standard C random number generator function, only numbers 0, 1, 256 and 257 are generated;
  * *killer-qs-r* &ndash; this sequence kills Hoare's Quicksort from its right edge;
  * *killer-qs-l* &ndash; this sequence kills Hoare's Quicksort from its left edge;
  * *reversed* &ndash; every next element is equal or lower than the previous;
  * *sorted* &ndash; every next element is equal or higher than the previous;
  * *constant* &ndash; all elements are equal.
  
The killer sequence generators may be taken from this [file](https://github.com/litwr2/research-of-sorting/blob/master/fillings.cpp), seek for *fill_for_quadratic_qsort_hoare* routines.

## Byte sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  273 |     + |      0 |      15
shell    |  185 |     - |      0 |      17
selection|  105 |     - |      0 |      13
insertion|   56 |     - |      0 |       9
radix8   |  179 |     - |    512 |      17

### 1000 byte benchmarking

  &nbsp; |    quick |    shell |  selection |  insertion | radix8
--------:|---------:|---------:|-----------:|-----------:|-------:
random-1 |  561,170 |  928,286 | 35,674,816 | 20,245,935 | 116,252
random-2 |  563,155 |  893,370 | 35,672,965 | 15,765,512 | 116,252
2-values |  592,443 |  531,099 | 35,661,547 |  9,836,179 | 116,288
reversed |  432,879 |  691,084 | 35,857,240 | 39,897,518 | 116,252
sorted   |  405,889 |  474,686 | 35,660,026 |     68,064 | 116,252
constant |  543,401 |  474,686 | 35,660,026 |     68,064 | 116,306

### 60000 byte benchmarking

  &nbsp; |     quick |     shell |     selection |     insertion |   radix8 
--------:|----------:|----------:|--------------:|--------------:|---------:
random-1 | 50,389,857| 81,808,734|127,934,952,030| 71,753,189,534| 6,138,752
random-2 | 52,883,426| 79,152,626|127,935,004,194| 71,361,558,850| 6,139,850
2-values | 53,288,673| 49,628,628|127,934,127,906| 35,873,116,983| 6,142,604
reversed | 40,879,061| 61,766,222|127,945,609,713|143,557,968,559| 6,138,752
sorted   | 39,279,506| 45,403,407|127,934,037,372|      4,084,222| 6,138,752
constant | 50,961,836| 45,403,407|127,934,037,372|      4,084,222| 6,142,622

## Word sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  303 |     + |      0 |      15
shell    |  203 |     - |      0 |      17
selection|   73 |     - |      0 |       9
insertion|  119 |     - |      0 |      13

### 1000 word benchmarking

  &nbsp; |     quick |    shell | selection | insertion 
--------:|----------:|---------:|----------:|----------:
random-1 |    854,763| 1,408,551| 56,734,545| 32,354,469
random-2 |    847,960| 1,327,684| 56,735,454| 27,659,096
4-values |    861,722|   720,618| 56,721,462| 24,218,444
kill-qs-r|  1,481,967| 1,143,970| 56,723,517| 21,276,935
kill-qs-l|  3,139,812| 1,138,930| 56,722,722| 21,276,591
reversed |    445,528|   962,602| 57,468,234| 63,558,642
sorted   |    401,247|   557,230| 56,718,234|     80,124
constant |    781,686|   557,230| 56,718,234|     80,124

### 30000 word benchmarking

  &nbsp; |     quick |     shell |     selection |    insertion 
--------:|----------:|----------:|--------------:|-------------:
random-1 | 34,091,790| 69,997,697| 50,918,498,814|28,620,322,011
random-2 | 34,223,170| 67,518,250| 50,918,502,168|28,465,154,836
4-values | 36,573,891| 31,495,608| 50,917,808,217|21,361,142,600
kill-qs-r| 57,823,525| 56,228,315| 50,917,870,428|19,072,438,388
kill-qs-l|102,682,131| 56,110,365| 50,917,845,840|19,072,437,339
reversed | 18,520,138| 43,534,213| 51,592,710,852|57,209,527,766
sorted   | 17,200,307| 26,299,401| 50,917,710,852|     2,404,210
constant | 35,401,769| 26,299,401| 50,917,710,852|     2,404,210

