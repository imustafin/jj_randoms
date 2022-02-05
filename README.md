# jj_randoms
### Eiffel implementation of the Merseene Twister and MELG Random Number Generators

This code is based on C-code described in Matsumoto and Nishimura's [Mersenne Twister](http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html) and the [Harase and Kimoto MELG repository](https://github.com/sharase/melg-64).  The MELG-based classes, like the original C-code versions, provide various period lengths from 2<sup>607</sup>-1 to 2<sup>44497</sup>-1.

This repository includes Eiffel classes for:

- [TWISTER_DEMO](./demo/twister_demo.e) -- Root class for system [twister_demo.ecf](./demo/twister_demo.ecf)
- [TWISTER_32](./classes/twister_32.e) -- 32-bit Mersenne Twister
- [TWISTER_64](./classes/twister_64.e) -- 64-bit Mersenne Twister

The MELG-type classes as well as the 64-bit Twister are based on
[MELG](./classes/melg.e) which contains all the functionality for the generators of various period lengths:

- [MELG_607](./classes/melg_607.e)
- [MELG_1279](./classes/melg_1279.e)
- [MELG_2281](./classes/melg_2281.e)
- [MELG_4253](./classes/melg_4253.e)
- [MELG_11213](./classes/melg_11213.e)
- [MELG_19937](./classes/melg_19937.e)
- [MELG_44497](./classes/melg_44497.e)


To conform to Eiffel's command-query separation principle, these classes depart from the paradym used in the C versions.

1.  Getting a random number does not advance the state (i.e. calling **item** multiple times returns the same random number).
2.  State advancement (i.e. moving to the next random number) is in feature **forth** which calls the non-exported feature **twist**.
3.  "Tempering" is handled in feature **forth**.

The demo program uses [melg_tests.e](./tests/melg_tests.e) in the [test directory](./tests) to display feature calls and the results of the calls.  It also verifies the output against files produced by the original C files.  When the demo system is open in [EiffelStudio](www.eiffel.com), you can also execute some features in [AutoTest](https://www.eiffel.org/doc/eiffelstudio/AutoTest).

