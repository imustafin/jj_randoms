note
	description: "[
		A 32-bit implementation of the Mersenne Twister algorithm originally
		described in "Mersenne Twister:  A 623-Dimensionally Equidistributed
		Uniform Pseudorandom Number Generator" by Makoto Matsumoto and Takuji
		Nishimura.
		
		Even though this class is not a MELG-type generator, it still
		inherts from {MELG}.  Having a common ancestor allows testing
		of this class in the same test file as all the {MELG} descendents.
		Some of the constants coming from TWISTER_64_CONSTANTS are not used
		here.  They were originally intended for {MELG} descendents, so 
		they had to be defined in the constants class.  Also, new constants
		were added in this class.
		
		Because it uses the same initialization features as the MELG classes,
		it generates a different sequence than the original C version.  This
		is because of the last line in feature `initialize'.  In the original
		version, the first bit of the first element in the state array, `mt',
		is set to one (mt[0] := 0x80000000); in the MELG classes, the first
		element is set differently (mt[0] := mt[0] | (One |<< 63).
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	TWISTER_64

inherit

	MELG
		redefine
			c_from_array,
			item,
			forth,
			twist
		end

	TWISTER_64_CONSTANTS
		undefine
			default_create
		end

create
	default_create,
	from_array

feature {NONE} -- Initialization


feature -- Access

	item: NATURAL_64
			-- The random number extracted from the current state.
			-- This is the "Tempering" code and also constrains the Result
			-- to be in the closed interval [lower, upper].
			-- This feature is called "extract_number()" on wiki.
		local
			y: NATURAL_64
		do
			check
				index_big_enough: index >= 0
				index_small_enough: index < mt.count
					-- because Current keeps its state in order		
			end
			y := mt[index]
			y := y.bit_xor (y.bit_shift_right (u).bit_and (d))
			y := y.bit_xor (y.bit_shift_left (s).bit_and (b))
			y := y.bit_xor (y.bit_shift_left (t).bit_and (c))
			y := y.bit_xor (y.bit_shift_right (z))
			Result := y
			if is_constrained then
				Result := Result \\ (upper - lower + One) + lower
			end
		end

feature -- Basic operations

	forth
			-- Increase the `index' by one.
		do
			index := index + 1
			if index = mt.count then
				twist
			end
		end

feature {NONE} -- Implementation

	twist
			-- Generate the next `nn' values in the series `mt'.
		local
			i: INTEGER
			x: NATURAL_64
		do
				-- See http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/MT2002/emt19937ar.html
			from i := 0
			until i >= nn - mm
			loop
				x := (mt[i] & Upper_mask) | (mt[i + 1] & Lower_mask)
				mt[i] := mt[i + mm] ⊕ (x |>> 1) ⊕ mag_1[(x & One).to_integer_32]
				i := i + 1
			end
			check
				correct_k: i = nn - mm
					-- because of loop condition
			end
			from
			until i >= nn - 1
			loop
				x := (mt[i] & Upper_mask) | (mt[i + 1] & Lower_mask)
				mt[i] := mt[i + (mm - nn)] ⊕ (x |>> 1) ⊕ mag_1[(x & One).to_integer_32]
				i := i + 1
			end
			x := (mt[nn - 1] & Upper_mask) | (mt[0] & Lower_mask)
			mt[nn - 1] := mt[mm - 1] ⊕ (x |>> 1) ⊕ mag_1[(x & One).to_integer_32]
				-- Common to both approaches
			index := 0
		ensure then
			index_set: index = 0
		end

feature {NONE} -- Implementation

	s: INTEGER = 17
			-- A bit shift for tempering in `item'.

	t: INTEGER  = 37
			-- A bit shift for tempering in `item'.

	u: INTEGER = 29
			-- A bit shift for tempering in `item'.

	z: INTEGER = 43
			-- A bit shift for tempering in `item'.
			-- Was called "l" (i.e. elle) in the original and on Wiki, but
			-- an elle looks too much like a one.

	a: NATURAL_64 = 0x9908B0DF
			-- The coefficients of the rational normal form twist matrix.

	b: NATURAL_64 = 0x71D67FFFEDA60000
			-- A tempering bitmask.

	c: NATURAL_64 = 0xFFF7EEE000000000
			-- A tempering bitmask.

	d: NATURAL_64 = 0x5555555555555555
			-- A tempering bitmask.

feature {NONE} -- Implementation

--	c_initialize (a_special: POINTER; a_count: INTEGER_32; a_seed: NATURAL_64)
--			-- Use C to perform the math, because C handles the overflow
--			-- in the multiplication of unsigned-long using promotions which
--			-- Eiffel does not do.  (Eiffel wraps natural numbers.)
--			-- Here is the main equation translated to Eiffel:
--			--   mt[i] := f * (mt[i - 1] ⊕ (mt[i - 1] |>> (w - 2))) + i.as_natural_32
--			-- The multiplier `f' and the bit-shift amount is hard-coded here.
--		external
--			"C inline"
--		alias
--			"{
--				EIF_INTEGER_32 N;
--				EIF_NATURAL_64 s;
--				EIF_NATURAL_64 *mt;

--				N = (EIF_INTEGER_32) $a_count;
--				s = (EIF_NATURAL_64) $a_seed;
--				mt = (EIF_NATURAL_64 *) $a_special;

--				mt[0] = s;
--				for (int i = 1; i < N; i++) {
--					mt[i] = 6364136223846793005ULL * (mt[i-1] ^ (mt[i-1] >> 62)) + i;
--				}
--			}"
--		end

	c_from_array (a_special: POINTER; a_count: INTEGER_32;
					a_init_special: POINTER; a_key_count: INTEGER_32)
			-- Use C to perform the math, because C handles the overflow
			-- in the multiplication of unsigned-long using promotions which
			-- Eiffel does not do.  (Eiffel wraps natural numbers.)
			-- Here are the two main equations translated to Eiffel:
			--   mt[i] := (mt[i] ⊕ ((mt[i - 1] ⊕ (mt[i - 1] |>> (w - 2))) *
			--	           Mult_1)) + a_array [j] + (j).as_natural_32
			--   mt[i] := (mt[i] ⊕ ((mt[i - 1] ⊕ (mt[i - 1] |>> (w - 2))) *
			--             Mult_2)) - i.as_natural_32
			-- The multipliers, `Mult_1' and `Mult_2', and the bit-shift
			-- amount are hard coded here.
		external
			"C inline"
		alias
			"{
				EIF_INTEGER_32 N;
				int i, j, k;
				EIF_INTEGER_32 key_length;
				EIF_NATURAL_64 *mt;
				EIF_NATURAL_64 *init_key;
			
				mt = (EIF_NATURAL_64 *) $a_special;
				init_key = (EIF_NATURAL_64 *) $a_init_special;
				N = (EIF_INTEGER_32) $a_count;
				key_length = (EIF_INTEGER_32) $a_key_count;
				
				i = 1;
				j = 0;
				k = (N > key_length ? N : key_length);
				for (; k; k--) {
					mt[i] = (mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 62)) * 3935559000370003845ULL))
							+ init_key[j] + j;
					i++; j++;
					if (i>=N) {
						mt[0] = mt[N-1];
						i=1;
					}
					if (j>=key_length) {
						j=0;
					}
				}
				for (k=N-1; k; k--) {
					mt[i] = (mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 62)) * 2862933555777941757ULL)) - i;
					i++;
					if (i>=N) {
						mt[0] = mt[N-1];
						i=1;
					}
			    }
			    	// Assure item 1 is non-zero, preventing non-zero initial array
				mt[0] = 1ULL << 63;
			}"
		end

end
