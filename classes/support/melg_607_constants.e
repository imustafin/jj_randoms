note
	description: "[
		Defines constants for the {MELG_607} Random Number Generator
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	MELG_607_CONSTANTS

feature {NONE} -- Implementation

	nn: INTEGER_32 = 9
			-- Number of elements in the state array
			-- Degreed of recurrence (wiki)

	mm: INTEGER_32 = 5
			-- Offset bit for middle word, an offset used in the recurrence
			-- relation defining the series, 1 <= mm < nn

	p: INTEGER_32 = 31
			-- W - R, where R is the seperation point of a word

	Lag_1: INTEGER_32 = 3
			-- Tempering bit-shift value ("elle" on wiki)

	Shift_1: INTEGER_32 = 30
			-- Tempering bit-shift value ("s" on wiki?)

	neg_shift: INTEGER_32 = 13
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_neg'.

	pos_shift: INTEGER_32 = 35
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_pos'.

	Mask_1: NATURAL_64 = 0x66edc62a6bf8c826
			-- Tempering bit-mask ("b" on wiki)

	matrix_a: NATURAL_64 = 0x81f1fd68012348bc
			-- 2nd value in the twist transformation matrix (see `Mag_1')

end
