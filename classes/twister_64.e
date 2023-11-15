note
	description: "[
		A 64-bit implementation of the Mersenne Twister algorithm originally
		described in "Mersenne Twister:  A 623-Dimensionally Equidistributed
		Uniform Pseudorandom Number Generator" by Makoto Matsumoto and Takuji
		Nishimura.

		This class generates random numbers of type {NATURAL_64}

		This implementation of the algorithm is modeled after the C-code
		developed by Matsumoto and Takuji.
		See:
		  http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/emt.html and
		  http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/emt64.html

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
	TWISTER_64

inherit

	ANY
		undefine
			default_create
		end

create
	default_create,
	from_array

feature {NONE} -- Initialization

	default_create
			-- Set up Current.
		do
			create mt.make_filled (Zero, nn)
			initialize (Default_seed)
			set_range (Min_value, Max_value)
			twist
		ensure then
			mt_array_sized_correctly: mt.count = nn
			seed_initialized: seed = Default_seed
			initial_index_set: index = 0
			range_initialized: lower = Min_value and upper = Max_value
		end

	from_seed (a_seed: NATURAL_64)
			-- Create an instance, initializing from `a_seed'
		do
			create mt.make_filled (Zero, nn)
			initialize (a_seed)
			set_range (Min_value, Max_value)
			twist
		ensure
			mt_array_sized_correctly: mt.count = nn
			seed_initialized: seed = a_seed
			initial_index_set: index = 0
			range_initialized: lower = Min_value and upper = Max_value
		end

	from_array (a_array: ARRAY [NATURAL_64])
			-- Create an instance, initializing from `a_array'
		local
			i, j, k: INTEGER_32
		do
			create mt.make_filled (Zero, nn)
			initialize (Array_seed)
			check attached {SPECIAL [NATURAL_64]} a_array.to_c as spec then
					-- c_initialize code converted to Eiffel
				i := 1
				j := 0
				from k := nn.max (a_array.count)
				until k <= 0
				loop
					mt[i] := (mt[i] ⊕ ((mt[i - 1] ⊕ (mt[i - 1] |>> 62)) * 3935559000370003845))
								+ spec[j] + j.as_natural_64
					i := i + 1
					j := j + 1
					if i >= nn then
						mt[0] := mt[nn - 1]
						i := 1
					end
					if j >= a_array.count then
						j := 0
					end
					k := k - 1
				end
				from k := nn - 1
				until k <= 0
				loop
					mt[i] := (mt[i] ⊕ ((mt[i - 1] ⊕ (mt[i - 1] |>> 62)) * 2862933555777941757)) - i.as_natural_64
					i := i+ 1
					if i >= nn then
						mt[0] := mt[nn - 1]
						i := 1
					end
					k := k - 1
				end
				mt[0] := One |<< 63
			end
			set_range (Min_value, Max_value)
			twist
		ensure
			mt_array_sized_correctly: mt.count = nn
			seed_initialized: seed = Array_seed
			initial_index_set: index = 0
			range_initialized: lower = Min_value and upper = Max_value
		end

	initialize (a_seed: NATURAL_64)
			-- Reset the generator from `a_seed'.
			-- Not a creation feature.
			-- Called by `default_crate', `from_seed', `from_array',
			-- and `set_seed'.
		local
			i: INTEGER
		do
			seed := a_seed
			mt[0] := seed
			from i := 1
			until i >= nn
			loop
				mt[i] := 6364136223846793005 * (mt[i - 1] ⊕ (mt[i - 1] |>> 62)) + i.as_natural_64
				i := i + 1
			end
		end

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

	item_63: REAL_64
			-- A random number in the closed interval [0, Max_value - 1]
		do
			Result := item |>> 1
		end

	real_item: REAL_64
			-- A random number in the closed interval [0, 1]
		require
			not_constrained: not is_constrained
		do
			Result := (item |>> 11) * (1.0 / 9007199254740991.0)
		ensure
			result_big_enough: Result >= 0.0
			Result_small_enought: Result <= 1.0
		end

	real_item_semi_open: REAL_64
			-- A random number in the semi-open interval [0, 1)
		require
			not_constrained: not is_constrained
		do
			Result := (item |>> 11) * (1.0 / 9007199254740992.0)
		ensure
			result_big_enough: Result >= 0.0
			Result_small_enought: Result < 1.0
		end

	real_item_open: REAL_64
			-- A random number in the open interval (0, 1)
		require
			not_constrained: not is_constrained
		do
			Result := ((item |>> 12) + 0.5) * (1.0 / 4503599627370496.0)
		ensure
			result_big_enough: Result > 0.0
			Result_small_enought: Result < 1.0
		end

	lower: NATURAL_64
			-- The smallest value returned by `item'.
			-- See `set_range'.

	upper: NATURAL_64
			-- The upper constraint for the possible values of `item'.
			-- See `set_range'.

	seed: NATURAL_64
			-- Value with which to initialize the generator

	Default_seed: NATURAL_64 = 5489
			-- The default value used for the `seed'.

	Array_seed: NATURAL_64 = 19650218
			-- The seed used when initializing from an array

	Min_value: NATURAL_64 = 0
			-- The minimum value allowed for `item'

	Max_value: NATURAL_64 = 18446744073709551615
			-- The maximum value allowed for `item

feature -- Element change

	set_range (a_lower, a_upper: NATURAL_64)
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

	set_seed (a_seed: NATURAL_64)
			-- Set the `seed' and reinitialize the generator.
		require
			non_zero: a_seed /= Min_value
		do
			seed := a_seed
			initialize (a_seed)
			twist
		ensure
			seed_assigned: seed = a_seed
		end

feature -- Basic operations

	forth
			-- Advance the state, so next call to `item' returns
			-- a new number.
		do
			index := index + 1
			if index >= mt.count then
				twist
				index := 0
			end
		ensure
			index_advanced: old index < mt.count - 1 implies index = old index + 1
			index_wrapped: old index = nn - 1 implies index = 0
		end

feature -- Status report

	is_constrained: BOOLEAN
			-- Should the numbers returned by `item' be restricted to a
			-- reduced range (i.e. other than [1, max_value]?

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
		end

feature {NONE} -- Implementation

	mt: SPECIAL [NATURAL_64]
			-- The state array

	index: INTEGER_32
			-- Index into the state array, `mt'

	Zero: NATURAL_64 = 0
			-- Then number zero in the Correct type

	One: NATURAL_64 = 1
			-- The number one in the Correct type

	w: INTEGER_32 = 64
			-- Number of bits in the implementation

	nn: INTEGER_32 = 312
			-- Number of elements in the state array
			-- Degreed of recurrence (wiki)

	mm: INTEGER_32 = 156
			-- Offset bit for middle word, an offset used in the recurrence
			-- relation defining the series, 1 <= mm < nn

	p: INTEGER_32 = 33
			-- W - R, where R is the seperation point of a word

	Upper_mask: NATURAL_64
			-- Mask to get the w - p, high-order bits
		once ("OBJECT")
			Result := 0xffffffffffffffff |<< (w - p)
		end

	Lower_mask: NATURAL_64
			-- Mask to get the low-order bits
		once ("OBJECT")
			Result := Upper_mask.bit_not
		end

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

	matrix_a: NATURAL_64 = 0xB5026F5AA96619E9
			-- 2nd value in the twist transformation matrix (see `Mag_1')

	Mag_1: SPECIAL [NATURAL_64]
			-- Bit-shift values used in tempering
		once ("OBJECT")
			create Result.make_filled (Min_value, 2)
			Result.put (Matrix_a, 1)
		ensure
			item_one_is_zero: Result.at (0) = 0
			item_two_is_correct: Result.at (1) = Matrix_a
		end

end
