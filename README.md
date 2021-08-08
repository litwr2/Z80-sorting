# Z80-sorting
implementations of various sorting algos for the Z80

For each sorting routine the next information is provided:  its size, whether it uses stack or not, required amount of additional memory, the size of code for its call.  All sizes are in bytes.  Benchmark results are clock cycles.  One clock cycle is equal to one millionth of a second for the Z80 at 1 MHz.  All results were gotten using Z80-sim Release 1.28 by Udo Munk.

Quicksort depends on its *stacklvl* parameter, it must be more than binary logarithm of the number of elements in the sorted array.  Number 26 is used as its default value (16 is enough for any case but it is slower).  Total amount of stack space required may be calculated by *stacklvl\*N*+*stackint* where *N=6* for *quick* and *N=4* for *quck-nr* (nr means no recursion), *stackint* is amount of stack space reserved for interrupts, it is 20 by default.  If interrupts are disabled *stackint* may be equal to 0.  An attempt to use quicksort when your system has less free space on stack causes the immidiate return with *C=1*, *C=0* means the sort is done successfully.

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

The killer sequence generators may be taken from this [file](https://github.com/litwr2/research-of-sorting/blob/master/fillings.cpp), seek for *fill_for_quadratic_qsort_hoare* routines.  The *random-2* generator is available within the same file, seek for *fill_homebrew_randomly* routine.

The standard C random generator (GCC) is initializared with *srand(0)*.

## Byte sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  164 |   180¹|      0 |      11
shell    |  149 |     4 |      0 |      11
selection|   56 |     4 |      0 |       9
insertion|   58 |     4 |      0 |       9
radix8   |  107 |     2 |    512 |      11

¹ - *stacklvl\*6 + stackint + 4*

### 1000 byte benchmarking

  &nbsp; |    quick |    shell |  selection |  insertion | radix8
--------:|---------:|---------:|-----------:|-----------:|-------:
random-1 |1,054,634 |1,843,095 | 35,674,816 | 28,878,343 | 212,273
random-2 |1,061,377 |1,798,425 | 35,672,965 | 22,496,347 | 212,273
2-values |1,127,435 |  982,630 | 35,661,547 | 14,049,135 | 212,293
reversed |  829,491 |1,279,909 | 35,857,240 | 56,873,005 | 212,273
sorted   |  775,468 |  895,729 | 35,660,026 |    135,048 | 212,273
constant |1,017,879 |  895,729 | 35,660,026 |    135,048 | 212,303

### 60000 byte benchmarking

  &nbsp; |     quick |     shell |     selection |     insertion |   radix8 
--------:|----------:|----------:|--------------:|--------------:|---------:
random-1 | 93,129,126|169,249,927|127,934,952,030|102,211,287,455|10,247,314
random-2 | 96,971,625|163,627,266|127,935,004,194|101,653,426,549|10,248,504
2-values |100,152,374|101,145,766|127,934,127,906| 51,101,831,035|10,249,454
reversed | 74,906,055|125,665,359|127,945,609,713|204,493,798,627|10,247,314
sorted   | 71,760,693| 92,315,601|127,934,037,372|      8,103,051|10,247,314
constant | 94,772,463| 92,315,601|127,934,037,372|      8,103,051|10,249,464

## Word sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  191 |   180¹|      0 |      11
shell    |  166 |     4 |      0 |      11
selection|   73 |     4 |      0 |       9
insertion|   75 |     4 |      0 |       9

### 1000 word benchmarking

  &nbsp; |     quick |    shell | selection | insertion 
--------:|----------:|---------:|----------:|----------:
random-1 |  1,617,316| 2,784,001| 56,734,545| 48,940,866
random-2 |  1,608,044| 2,766,537| 56,735,454| 41,846,478
4-values |  1,602,284| 1,471,940| 56,721,462| 36,646,675
kill-qs-r|  2,682,834| 2,328,209| 56,723,517| 32,202,093
kill-qs-l|  6,163,626| 2,310,207| 56,722,722| 32,201,585
reversed |    857,848| 1,884,897| 57,468,234| 96,075,429
sorted   |    780,859| 1,180,111| 56,718,234|    173,066
constant |  1,431,404| 1,180,111| 56,718,234|    173,066

### 30000 word benchmarking

  &nbsp; |     quick |     shell |     selection |    insertion 
--------:|----------:|----------:|--------------:|-------------:
random-1 | 63,675,436|147,334,447| 50,918,498,814|43,247,740,411
random-2 | 63,954,406|142,326,158| 50,918,502,168|43,013,279,365
4-values | 67,182,158| 69,300,965| 50,917,808,217|32,278,898,846
kill-qs-r|105,135,304|119,597,489| 50,917,870,428|28,820,597,113
kill-qs-l|200,652,479|119,242,046| 50,917,845,840|28,820,595,461
reversed | 35,332,138| 93,260,287| 51,592,710,852|86,446,438,341
sorted   | 33,050,832| 59,047,839| 50,917,710,852|     5,193,017
constant | 64,289,236| 59,047,839| 50,917,710,852|     5,193,017

Check also [6502-sorting](https://github.com/litwr2/6502-sorting) and [6809-sorting](https://github.com/litwr2/6809-sorting).
