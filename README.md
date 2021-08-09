# Z80-sorting
implementations of various sorting algos for the Z80

For each sorting routine the next information is provided:  its size, whether it uses stack or not, required amount of additional memory, the size of code for its call.  All sizes are in bytes.  Benchmark results are clock cycles.  One clock cycle is equal to one millionth of a second for the Z80 at 1 MHz.  All results were gotten using Z80-sim Release 1.28 by Udo Munk.

Quicksort depends on its *stacklvl* parameter, it must be more than binary logarithm of the number of elements in the sorted array.  Number 26 is used as its default value (16 is enough for any case but it is slower).  Total amount of stack space required may be calculated by *stacklvl\*N*+*stackint* where *N=6* for *quick* and *N=4* for *quick-nr* (nr means no recursion), *stackint* is amount of stack space reserved for interrupts, it can be, for instance, 20 but this value is not used by code.  If interrupts are disabled *stackint* may be equal to 0.  You can check if your stack space is large enough before the sort invocation.

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
quick    |  147 |   180¹|      0 |       9
quick-nr |  171 |   128²|      0 |       9
shell    |  149 |     4 |      0 |      11
selection|   56 |     4 |      0 |       9
insertion|   58 |     4 |      0 |       9
radix8   |  107 |     2 |    512 |      11

¹ - *stacklvl\*6+stackint+4*

² - *stacklvl\*4+stackint+4*

### 1000 byte benchmarking

  &nbsp; |    quick | quick-nr |    shell |  selection |  insertion | radix8
--------:|---------:|---------:|---------:|-----------:|-----------:|-------:
random-1 |1,007,074 |1,064,935 |1,843,095 | 35,674,816 | 28,878,343 | 212,273
random-2 |1,014,328 |1,055,045 |1,798,425 | 35,672,965 | 22,496,347 | 212,273
2-values |1,083,501 |1,070,722 |  982,630 | 35,661,547 | 14,049,135 | 212,293
reversed |  782,898 |  891,726 |1,279,909 | 35,857,240 | 56,873,005 | 212,273
sorted   |  728,930 |  837,385 |  895,729 | 35,660,026 |    135,048 | 212,273
constant |  987,696 |  978,599 |  895,729 | 35,660,026 |    135,048 | 212,303

### 60000 byte benchmarking

  &nbsp; |     quick |  quick-nr |     shell |     selection |     insertion |   radix8 
--------:|----------:|----------:|----------:|--------------:|--------------:|---------:
random-1 | 90,553,643| 89,837,259|169,249,927|127,934,952,030|102,211,287,455|10,247,314
random-2 | 90,999,522| 90,274,125|163,627,266|127,935,004,194|101,653,426,549|10,248,504
2-values | 97,414,382| 96,579,687|101,145,766|127,934,127,906| 51,101,831,035|10,249,454
reversed | 72,825,504| 72,421,136|125,665,359|127,945,609,713|204,493,798,627|10,247,314
sorted   | 69,683,918| 69,280,702| 92,315,601|127,934,037,372|      8,103,051|10,247,314
constant | 92,839,176| 92,249,471| 92,315,601|127,934,037,372|      8,103,051|10,249,464

## Word sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  174 |   180¹|      0 |       9
quick-nr |  198 |   128²|      0 |       9
shell    |  166 |     4 |      0 |      11
selection|   73 |     4 |      0 |       9
insertion|   75 |     4 |      0 |       9

### 1000 word benchmarking

  &nbsp; |     quick |  quick-nr |    shell | selection | insertion 
--------:|----------:|----------:|---------:|----------:|----------:
random-1 |  1,564,002|  1,685,422| 2,784,001| 56,734,545| 48,940,866
random-2 |  1,556,627|  1,665,513| 2,766,537| 56,735,454| 41,846,478
4-values |  1,552,277|  1,538,181| 1,471,940| 56,721,462| 36,646,675
kill-qs-r|  2,633,958|  2,640,566| 2,328,209| 56,723,517| 32,202,093
kill-qs-l|  6,112,227|  2,890,008| 2,310,207| 56,722,722| 32,201,585
reversed |    827,665|    818,568| 1,884,897| 57,468,234| 96,075,429
sorted   |    750,676|    741,579| 1,180,111| 56,718,234|    173,066
constant |  1,401,221|  1,392,124| 1,180,111| 56,718,234|    173,066

### 30000 word benchmarking

  &nbsp; |     quick |  quick-nr |     shell |     selection |    insertion 
--------:|----------:|----------:|----------:|--------------:|-------------:
random-1 | 62,115,610| 65,418,565|147,334,447| 50,918,498,814|43,247,740,411
random-2 | 61,835,265| 64,312,641|142,326,158| 50,918,502,168|43,013,279,365
4-values | 65,861,873| 65,460,358| 69,300,965| 50,917,808,217|32,278,898,846
kill-qs-r|103,494,444|103,398,040|119,597,489| 50,917,870,428|28,820,597,113
kill-qs-l|199,196,775|128,300,498|119,242,046| 50,917,845,840|28,820,595,461
reversed | 34,365,507| 34,070,714| 93,260,287| 51,592,710,852|86,446,438,341
sorted   | 32,084,201| 31,789,408| 59,047,839| 50,917,710,852|     5,193,017
constant | 63,322,605| 63,027,812| 59,047,839| 50,917,710,852|     5,193,017

Check also [6502-sorting](https://github.com/litwr2/6502-sorting) and [6809-sorting](https://github.com/litwr2/6809-sorting).
