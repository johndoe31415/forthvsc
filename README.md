# forthvsc
While Forth advocates routinely describe Forth in the most beautiful colors, I
could not find any actual benchmarking comparing Forth to C. There's a
[reference implementation of RC4 on Wikipedia](https://en.wikipedia.org/wiki/Forth_(programming_language)#A_complete_RC4_cipher_program)
which I took to perform benchmarking with. I also took the
[RC4 description on Wikipedia](https://en.wikipedia.org/wiki/RC4#Key-scheduling_algorithm_(KSA))
and implemented it naively in C with no optimizations whatsoever, just the
algorithm as it was described in pseudocode there.

## Test Conditions
Measured on an Intel Core i7-5930K CPU @ 3.50GHz using gcc 8.3.0 and gforth
0.7.3 on Linux 5.0.0. Since the speed difference is so vast, the number of
generated schedules/keystream varies from C to Forth, consult the code for
details.

## Forth: Key Schedules
```
$ time gforth key_schedules.for

real	0m21,616s
user	0m21,616s
sys	0m0,000s

$ time gforth key_schedules.for

real	0m21,573s
user	0m21,568s
sys	0m0,004s

$ time gforth key_schedules.for
real	0m21,682s
user	0m21,682s
sys	0m0,000s
```
Best of three: 21.573 seconds.

## Forth: RC4 Data Stream
```
$ time gforth key_stream.for

real	0m19,560s
user	0m19,559s
sys	0m0,001s

$ time gforth key_stream.for
real	0m19,595s
user	0m19,595s
sys	0m0,001s

$ time gforth key_stream.for
real	0m19,601s
user	0m19,592s
sys	0m0,009s
```

Best of three: 19.560 seconds.

## C: Key Schedules
```
$ gcc -Wall -O3 -o rc4_c_impl rc4_c_impl.c
$ time ./rc4_c_impl schedule
real	0m6,822s
user	0m6,822s
sys	0m0,000s

$ time ./rc4_c_impl schedule
real	0m6,843s
user	0m6,843s
sys	0m0,000s

$ time ./rc4_c_impl schedule
real	0m6,946s
user	0m6,946s
sys	0m0,000s
```

Best of three: 6.822 seconds.

## C: RC4 Data Stream
```
$ gcc -Wall -O3 -o rc4_c_impl rc4_c_impl.c
$ time ./rc4_c_impl stream
real	0m5,990s
user	0m5,986s
sys	0m0,004s

$ time ./rc4_c_impl stream
real	0m6,001s
user	0m6,001s
sys	0m0,000s

$ time ./rc4_c_impl stream
real	0m5,976s
user	0m5,975s
sys	0m0,001s
```

Best of three: 5.976 seconds.

## Comparison

| Test          | Language | Iterations | Time/sec  | Iterations/Time | Factor |
| --- | --- | --- | --- | --- | --- |
| Key Schedules | Forth    | 100000     | 21.573    | 4635            | 1      |
|               | C        | 10000000   | 6.822     | 1465846		  | 316    |
| Key Stream    | Forth    | 10000000   | 19.560    | 511247          | 1      |
|               | C        | 2000000000 | 5.976     | 334672021       | 655    |

I.e., in Forth on this particular test you get about 4.64 kSchedules/sec while
in C you get 1.47 MSchedules/sec. In Forth, you get a data stream with about
511 kB/s while in C you get 335 MB/s.

## License
All my code is CC-0. Forth code was taken from Wikipedia and is under the
respective license.
