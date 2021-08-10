# Z80-sorting
implementations of various sorting algos for the Z80

For each sorting routine the next information is provided:  its size, whether it uses stack or not, required amount of additional memory, the size of code for its call.  All sizes are in bytes.  Benchmark results are clock cycles.  One clock cycle is equal to one millionth of a second for the Z80 at 1 MHz.  All results were gotten using Z80-sim Release 1.37 by Udo Munk.

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
quick    |  136 |   178¹|      0 |       9
quick-nr |  162 |   126²|      0 |       9
shell    |  145 |     4 |      0 |      11
selection|   56 |     4 |      0 |       9
insertion|   58 |     4 |      0 |       9
radix8   |  104 |     2 |    512 |      11

¹ - *stacklvl\*6+stackint+2*

² - *stacklvl\*4+stackint+2*

### 1000 byte benchmarking

  &nbsp; |    quick | quick-nr |    shell |  selection |  insertion | radix8
--------:|---------:|---------:|---------:|-----------:|-----------:|-------:
random-1 |  883,128 |  915,005 | 1,843,009| 35,674,816 | 28,878,343 | 204,713
random-2 |  891,203 |  908,092 | 1,798,339| 35,672,965 | 22,496,347 | 204,713
2-values |  894,137 |  864,946 |   982,544| 35,661,547 | 14,049,135 | 204,733
reversed |  717,064 |  794,384 | 1,279,823| 35,857,240 | 56,873,005 | 204,713
sorted   |  680,902 |  757,909 |   895,643| 35,660,026 |    135,048 | 204,713
constant |  811,001 |  790,684 |   895,643| 35,660,026 |    135,048 | 204,743

### 60000 byte benchmarking

  &nbsp; |     quick |  quick-nr |     shell |     selection |     insertion |   radix8 
--------:|----------:|----------:|----------:|--------------:|--------------:|---------:
random-1 | 77,270,026| 75,585,298|169,277,763|127,934,952,030|102,211,287,455| 9,944,754
random-2 | 77,570,788| 75,878,999|162,645,693|127,935,004,194|101,653,426,549| 9,945,554
2-values | 79,907,044| 78,051,373|101,150,601|127,934,127,906| 51,101,831,035| 9,946,894
reversed | 62,993,150| 61,786,498|125,707,217|127,945,609,713|204,493,798,627| 9,944,754
sorted   | 60,843,906| 59,639,814| 92,315,475|127,934,037,372|      8,103,051| 9,944,754
constant | 75,976,637| 74,666,080| 92,315,475|127,934,037,372|      8,103,051| 9,946,904

## Word sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  167 |   178¹|      0 |       9
quick-nr |  193 |   126²|      0 |       9
shell    |  162 |     4 |      0 |      11
selection|   73 |     4 |      0 |       9
insertion|   75 |     4 |      0 |       9

### 1000 word benchmarking

  &nbsp; |     quick |  quick-nr |    shell | selection | insertion 
--------:|----------:|----------:|---------:|----------:|----------:
random-1 |  1,504,087|  1,608,183| 2,786,334| 56,734,545| 48,940,866
random-2 |  1,502,319|  1,594,525| 2,767,763| 56,735,454| 41,846,478
4-values |  1,442,949|  1,410,265| 1,473,617| 56,721,462| 36,646,675
kill-qs-r|  2,623,831|  2,612,699| 2,329,927| 56,723,517| 32,202,093
kill-qs-l|  6,105,287|  2,865,651| 2,310,531| 56,722,722| 32,201,585
reversed |    843,000|    822,683| 1,889,321| 57,468,234| 96,075,429
sorted   |    775,220|    754,903| 1,180,025| 56,718,234|    173,066
constant |  1,325,078|  1,304,761| 1,180,025| 56,718,234|    173,066

### 30000 word benchmarking

  &nbsp; |     quick |  quick-nr |     shell |     selection |    insertion 
--------:|----------:|----------:|----------:|--------------:|-------------:
random-1 | 59,745,096| 62,544,459|147,349,040| 50,918,498,814|43,247,740,411
random-2 | 59,355,352| 61,341,456|141,033,666| 50,918,502,168|43,013,279,365
4-values | 61,677,795| 60,784,004| 69,305,677| 50,917,808,217|32,278,898,846
kill-qs-r|103,456,298|102,755,656|119,606,055| 50,917,870,428|28,820,597,113
kill-qs-l|198,970,477|127,941,471|119,252,416| 50,917,845,840|28,820,595,461
reversed | 34,896,198| 34,241,001| 93,275,905| 51,592,710,852|86,446,438,341
sorted   | 32,870,601| 32,215,404| 59,047,713| 50,917,710,852|     5,193,017
constant | 59,587,826| 58,932,629| 59,047,713| 50,917,710,852|     5,193,017

Check also [6502-sorting](https://github.com/litwr2/6502-sorting) and [6809-sorting](https://github.com/litwr2/6809-sorting).
