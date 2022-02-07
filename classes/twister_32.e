note
	description: "[
		A 32-bit implementation of the Mersenne Twister algorithm originally
		described in "Mersenne Twister:  A 623-Dimensionally Equidistributed
		Uniform Pseudorandom Number Generator" by Makoto Matsumoto and Takuji
		Nishimura.

		This class generates random numbers of type {NATURAL_32}
		
		This implementation of the algorithm is modeled after the C-code
		developed by Matsumot and Takuji.
		See:
		  http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/emt.html and
		  http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/MT2002/emt19937ar.html

		This class adapts the code to a more Eiffel-like interface.
		  1) Getting a random number does not advance the state.  Calling
		     `item' multiple times without calling `forth' will return
		     the same value.
		  2) Feature `forth' advances the state by incrementing the index
		     and then calling `twist'.
		  3) Feature `twist' advances the state vector.
		  4) The "tempering" equations are in feature `item'.
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	TWISTER_32

inherit

	ANY
		redefine
			default_create
		end

create
	default_create,
	from_array

feature {NONE} -- Initialization

	default_create
			-- Set up Current.
		do
			create mt.make_filled (Zero, n)
			initialize (Default_seed)
			set_range (Min_value, Max_value)
			twist
		ensure then
			mt_array_sized_correctly: mt.count = n
			seed_initialized: seed = Default_seed
			initial_index_set: index = 0
			range_initialized: lower = Min_value and upper = Max_value
		end

	from_seed (a_seed: NATURAL_32)
			-- Create an instance, initializing from `a_seed'
		do
			create mt.make_filled (Zero, n)
			initialize (a_seed)
			set_range (Min_value, Max_value)
			twist
		ensure
			mt_array_sized_correctly: mt.count = n
			seed_initialized: seed = a_seed
			initial_index_set: index = 0
			range_initialized: lower = Min_value and upper = Max_value
		end

	from_array (a_array: ARRAY [NATURAL_32])
			-- Create an instance, initializing from `a_array'
		do
			create mt.make_filled (Zero, n)
			initialize (Array_seed)
			check attached {SPECIAL [NATURAL_32]} a_array.to_c as init_key then
				c_from_array ($mt, mt.count, $init_key, init_key.count)
			end
				-- Set the range
			set_range (Min_value, Max_value)
			twist
		ensure
			mt_array_sized_correctly: mt.count = n
			seed_initialized: seed = Array_seed
			initial_index_set: index = 0
			range_initialized: lower = Min_value and upper = Max_value
		end

	initialize (a_seed: NATURAL_32)
			-- Reset the generator from `seed'.
			-- Not a creation feature.
			-- Called by `set_seed' in `default_crate' and `from_array'.
		do
			seed := a_seed
			c_initialize ($mt, mt.count, seed)
		end

feature -- Access

	item: NATURAL_32
			-- The random number extracted from the current state.
			-- This is the "Tempering" code and also constrains the Result
			-- to be in the closed interval [lower, upper].
		local
			y: NATURAL_32
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

	item_31: NATURAL_32
			-- A random number in the closed interval [0, Max_value - 1]
		do
			Result := item |>> 1
		end

	real_item: REAL_32
			-- A random number in the closed interval [0, 1]
		require
			not_constrained: not is_constrained
		do
			Result := ((item |>> 11) * (1.0 / 4294967295.0)).truncated_to_real
		ensure
			result_big_enough: Result >= 0.0
			Result_small_enought: Result <= 1.0
		end

	real_item_semi_open: REAL_32
			-- A random number in the semi-open interval [0, 1)
		require
			not_constrained: not is_constrained
		do
			Result := ((item |>> 11) * (1.0 / 4294967296.0)).truncated_to_real
		ensure
			result_big_enough: Result >= 0.0
			Result_small_enought: Result < 1.0
		end

	real_item_open: REAL_32
			-- A random number in the open interval (0, 1)
		require
			not_constrained: not is_constrained
		do
			Result := (((item |>> 12) + 0.5) * (1.0 / 4294967296.0)).truncated_to_real
		ensure
			result_big_enough: Result > 0.0
			Result_small_enought: Result < 1.0
		end

	lower: NATURAL_32
			-- The smallest value returned by `item'.
			-- See `set_range'.

	upper: NATURAL_32
			-- The upper constraint for the possible values of `item'.
			-- See `set_range'.

	seed: NATURAL_32
			-- Value to initialize the generator

	Default_seed: NATURAL_32 = 5489
			-- The default value used for the `seed'.

	Array_seed: NATURAL_32 = 19650218
			-- The seed used when initializing from an array

	Min_value: NATURAL_32 = 0
			-- The minimum value allowed for `item'

	Max_value: NATURAL_32 = 4294967295
			-- The maximum value allowed for `item

feature -- Element change

	set_range (a_lower, a_upper: NATURAL_32)
			-- Set `lower' and `upper' such that a call to `item' returns
			-- a number in the closed interval [`lower', `upper'].
		require
			lower_smaller_than_upper: a_lower <= a_upper
		do
			lower := a_lower
			upper := a_upper
			if lower > Min_value or upper < Max_value then
				is_constrained := true
			else
				is_constrained := false
			end
		ensure
			lower_set: lower = a_lower
			upper_set: upper = a_upper
			implication: (a_lower /= 0 or a_upper /= Max_value) implies is_constrained
		end

	set_seed (a_seed: NATURAL_32)
			-- Set the `seed' and reinitialize the generator.
		require
			non_zero: a_seed /= Min_value
		do
			seed := a_seed
			initialize (seed)
		ensure
			seed_assigned: seed = a_seed
		end

feature -- Basic operations

	forth
			-- Advance the state, so next call to `item' returns
			-- a new number.
		do
			index := index + 1
			if index = n then
				twist
			end
		ensure
			index_incremented: ((old index = n - 1) implies index = 0) or else
								 index = old index + 1
		end

feature -- Status report

	is_constrained: BOOLEAN
			-- Should the numbers returned by `item' be restricted to a
			-- reduced range (i.e. other than [1, max_value]?

feature {NONE} -- Implementation

	twist
			-- Generate the next `n' values in the series `mt'.
			-- See mt19937ar-cok.c to see if this feature can be
			-- broken down similarly:
			--   #define MIXBITS(u,v) ( ((u) & UMASK) | ((v) & LMASK) )
			--   #define TWIST(u,v) ((MIXBITS(u,v) >> 1) ^ ((v)&1UL ? MATRIX_A : 0UL))
		local
			k: INTEGER
			y: NATURAL_32
		do
				-- See http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/MT2002/emt19937ar.html
			from k := 0
			until k >= n - m
			loop
				y := (mt[k] & Upper_mask) | (mt[k + 1] & Lower_mask)
				mt[k] := mt[k + m] ⊕ (y |>> 1) ⊕ mag_1[(y & one).to_integer_32]
				k := k + 1
			end
			check
				correct_k: k = n - m
					-- because of loop condition
			end
			from
			until k >= n - 1
			loop
				y := (mt[k] & Upper_mask) | (mt[k + 1] & Lower_mask)
				mt[k] := mt[k + (m - n)] ⊕ (y |>> 1) ⊕ Mag_1[(y & one).to_integer_32]
				k := k + 1
			end
			y := (mt[n - 1] & Upper_mask) | (mt[0] & Lower_mask)
			mt[n - 1] := mt[m - 1] ⊕ (y |>> 1) ⊕ Mag_1[(y & one).to_integer_32]
				-- Common to both approaches
			index := 0
		ensure
			index_set: index = 0
		end

feature {NONE} -- Implementation

	mt: SPECIAL [NATURAL_32]
			-- State array of the generator.

	index: INTEGER_32
			-- Index into the state array (i.e. part of the state)

feature {NONE} -- Implementation (constants)

	Zero: NATURAL_32 = 0
			-- Then number zero in the Correct type

	One: NATURAL_32 = 1
			-- The number one in the Correct type

	n: INTEGER = 624
			-- The number of items in the state array.

	m: INTEGER = 397
			-- Middle word, an offset used in the recurrence relation
			-- defining the series.

	s: INTEGER = 7
			-- A bit shift for tempering in `item'.

	t: INTEGER  = 15
			-- A bit shift for tempering in `item'.

	u: INTEGER = 11
			-- A bit shift for tempering in `item'.

	z: INTEGER = 18
			-- A bit shift for tempering in `item'.
			-- Was called "l" (i.e. elle) in the original and on Wiki, but
			-- an elle looks too much like a one.

	a: NATURAL_32 = 0x9908B0DF
			-- The coefficients of the rational normal form twist matrix.

	b: NATURAL_32 = 0x9D2C5680
			-- A tempering bitmask.

	c: NATURAL_32 = 0xEFC60000
			-- A tempering bitmask.

	d: NATURAL_32 = 0xFFFFFFFF
			-- A tempering bitmask.

	lower_mask: NATURAL_32 = 0x7FFFFFFF
			-- Mask to obtain the lower `r' bits of a particular
			-- value from `mt'.

	upper_mask: NATURAL_32 = 0x80000000	--0xFFFF8000
			-- Mask to obtain the upper `w' - `r' bits of a particular
			-- value from `mt'.

	Matrix_a: NATURAL_32 = 0x9908B0DF
			-- Constant returned in second item in `Mag_01'

	Mag_1: ARRAY [NATURAL_32]
			-- A zero-index array indexed based on the magnitude of
			-- the lowest-order bit (i.e. item one or item zero)
			-- I think this is to avoid a multiplication in `twist'.
			-- Would be better if this were constant.
		once ("OBJECT")
			create Result.make_filled (Min_value, 0, 1)
			Result.put (Matrix_a, 1)
		ensure
			item_one_is_zero: Result.at (0) = 0
			item_two_is_correct: Result.at (1) = Matrix_a
		end

feature {NONE} -- Implementation

	c_initialize (a_special: POINTER; a_count: INTEGER_32; a_seed: NATURAL_32)
			-- Use C to perform the math, because C handles the overflow
			-- in the multiplication of unsigned-long using promotions which
			-- Eiffel {NATURAL_32} does not do.  (Eiffel wraps the numbers.)
		external
			"C inline"
		alias
			"{
				int N;
				EIF_NATURAL_32 s;
				EIF_NATURAL_32 *mt;
				unsigned long long v;

				N = (EIF_INTEGER_32) $a_count;
				s = (EIF_NATURAL_32) $a_seed;
				mt = (EIF_NATURAL_32 *) $a_special;

				mt[0] = s & 0xffffffffUL;
				for (int i = 1; i < N; i++) {
					v = 1812433253UL * (mt[i-1] ^ (mt[i-1] >> 30)) + i;
					mt[i] = (EIF_NATURAL_32) (0xffffffffUL & v);
				}
			}"
		end

	c_from_array (a_special: POINTER; a_count: INTEGER_32;
					a_init_special: POINTER; a_key_count: INTEGER_32)
			-- Use C to perform the math, because C handles the overflow
			-- in the multiplication of unsigned-long using promotions which
			-- Eiffel {NATURAL_32} does not do.  (Eiffel wraps the numbers.)
		external
			"C inline"
		alias
			"{
				EIF_INTEGER_32 N;
				int i, j, k;
				EIF_INTEGER_32 key_length;
				EIF_NATURAL_32 *mt;
				EIF_NATURAL_32 *init_key;
			
				mt = (EIF_NATURAL_32 *) $a_special;
				init_key = (EIF_NATURAL_32 *) $a_init_special;
				N = (EIF_INTEGER_32) $a_count;
				key_length = (EIF_INTEGER_32) $a_key_count;
				
				i = 1;
				j = 0;
				k = (N > key_length ? N : key_length);
				for (; k; k--) {
					mt[i] = (mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 30)) * 1664525UL))
							+ init_key[j] + j;
					mt[i] &= 0xffffffffUL; /* for WORDSIZE > 32 machines */
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
					mt[i] = (mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 30)) * 1566083941UL)) - i;
					mt[i] &= 0xffffffffUL; /* for WORDSIZE > 32 machines */
					i++;
					if (i>=N) {
						mt[0] = mt[N-1];
						i=1;
					}
			    }
			    	// Assure item 1 is non-zero, preventing non-zero initial array
				mt[0] = 0x80000000UL;
			}"
		end

invariant

	valid_item: item >= lower and item <= upper

	index_big_enough: index >= 0
	index_small_enough: index < n

	lower_big_enough: lower >= Min_value
	lower_small_enough: lower <= Max_value

	upper_big_enough: upper >= Min_value
	upper_small_enough: upper <= Max_value

	lower_smaller_than_upper: lower <= upper

	is_constrained_implication: is_constrained implies (lower > Min_value or upper < Max_value)
	reduced_range_implication: (lower > Min_value or upper < Max_value) implies is_constrained

end
