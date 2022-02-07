note
	description: "[
		Defines constants for the {TWISTER_64} Random Number Generator.
		Some of the constants are not used, because this class was originally
		intended for descendents of {MELG}.  {TWISTER_64} inherits
		from {MELG} just to simplify testing (i.e. give the test objects
		a common ancestor.
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"


class
	TWISTER_64_CONSTANTS

feature {NONE} -- Implementation

	nn: INTEGER_32 = 312
			-- Number of elements in the state array
			-- Degreed of recurrence (wiki)

	mm: INTEGER_32 = 156
			-- Offset bit for middle word, an offset used in the recurrence
			-- relation defining the series, 1 <= mm < nn

	p: INTEGER_32 = 33
			-- W - R, where R is the seperation point of a word

	Lag_1: INTEGER_32 = 0
			-- Tempering bit-shift value ("elle" on wiki)

	Shift_1: INTEGER_32 = 0
			-- Tempering bit-shift value ("s" on wiki?)

	neg_shift: INTEGER_32 = 0
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_neg'.

	pos_shift: INTEGER_32 = 0
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_pos'.

	Mask_1: NATURAL_64 = 0x6aede6fd97b338ec
			-- Tempering bit-mask ("b" on wiki)

	matrix_a: NATURAL_64 = 0xB5026F5AA96619E9
			-- 2nd value in the twist transformation matrix (see `Mag_1')

	jump_strings: ARRAY [STRING_8]
			-- Helper feature to ease the creation of `jump_chars'
			-- (See https://github.com/sharase/melg-64)
		do
			check
				do_not_call: false then
					-- because feature irrelavent for this class
			end
			Result := <<
				"  fix me  "
				>>
		end

end
