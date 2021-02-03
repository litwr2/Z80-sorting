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
insertion|   55 |     - |      0 |       6
radix8   |  179 |     - |    512 |      17

### 1000 byte benchmarking

  &nbsp; |    quick |    shell |  selection |  insertion | radix8
--------:|---------:|---------:|-----------:|-----------:|-------:
random-1 |  561,170 |  928,286 | 53,634,922 | 20,245,935 | 116,252
random-2 |  563,155 |  893,370 | 51,388,612 | 15,765,512 | 116,252
2-values |  592,443 |  531,099 | 61,581,602 |  9,836,179 | 116,288
reversed |  432,879 |  691,084 | 57,451,654 | 39,897,518 | 116,252
sorted   |  405,889 |  474,686 | 35,793,286 |     68,064 | 116,252
constant |  543,401 |  474,686 | 70,151,878 |     68,064 | 116,306

### 60000 byte benchmarking

  &nbsp; |     quick |     shell |     selection |     insertion |   radix8 
--------:|----------:|----------:|--------------:|--------------:|---------:
random-1 | 50,389,857| 81,808,734| 73,841,817,736| 71,753,189,534| 6,138,752
random-2 | 52,883,426| 79,152,626| 73,842,009,004| 71,361,558,850| 6,139,850
2-values | 53,288,673| 49,628,628| 73,838,795,948| 35,873,116,983| 6,142,604
reversed | 40,879,061| 61,766,222|190,340,951,766|143,557,968,559| 6,138,752
sorted   | 39,279,506| 45,403,407| 73,838,463,990|      4,084,222| 6,138,752
constant | 50,961,836| 45,403,407| 73,838,463,990|      4,084,222| 6,142,622

## Word sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  303 |     + |      0 |      15
shell    |  203 |     - |      0 |      17
selection|   72 |     - |      0 |       6
insertion|  119 |     - |      0 |      13

### 1000 word benchmarking

  &nbsp; |     quick |    shell | selection | insertion 
--------:|----------:|---------:|----------:|----------:
random-1 |    854,763| 1,408,551| 85,087,901| 32,354,469
random-2 |    847,960| 1,327,684| 84,320,139| 27,659,096
4-values |    861,722|   720,618| 92,004,662| 24,218,444
kill-qs-r|  1,481,967| 1,143,970| 84,968,940| 21,276,935
kill-qs-l|  3,139,812| 1,138,930| 84,943,824| 21,276,591
reversed |    445,528|   962,602| 84,503,370| 63,558,642
sorted   |    401,247|   557,230| 56,718,234|     80,124
constant |    781,686|   557,230|112,224,222|     80,124

### 30000 word benchmarking

  &nbsp; |     quick |     shell |     selection |    insertion 
--------:|----------:|----------:|--------------:|-------------:
random-1 | 34,091,790| 69,997,697| 23,864,359,064|28,620,322,011
random-2 | 34,223,170| 67,518,250| 23,864,371,362|28,465,154,836
4-values | 36,573,891| 31,495,608| 23,861,826,875|21,361,142,600
kill-qs-r| 57,823,525| 56,228,315| 23,862,054,982|19,072,438,388
kill-qs-l|102,682,131| 56,110,365| 23,861,964,826|19,072,437,339
reversed | 18,520,138| 43,534,213| 26,336,469,870|57,209,527,766
sorted   | 17,200,307| 26,299,401| 50,917,710,852|     2,404,210
constant | 35,401,769| 26,299,401|100,929,057,372|     2,404,210

