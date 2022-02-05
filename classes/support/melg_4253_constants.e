note
	description: "[
		Defines constants for the {MELG_4253} Random Number Generator
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	MELG_4253_CONSTANTS

feature {NONE} -- Implementation

	nn: INTEGER_32 = 66
			-- Number of elements in the state array
			-- Degreed of recurrence (wiki)

	mm: INTEGER_32 = 29
			-- Offset bit for middle word, an offset used in the recurrence
			-- relation defining the series, 1 <= mm < nn

	p: INTEGER_32 = 29
			-- W - R, where R is the seperation point of a word

	Lag_1: INTEGER_32 = 9
			-- Tempering bit-shift value ("elle" on wiki)

	Shift_1: INTEGER_32 = 5
			-- Tempering bit-shift value ("s" on wiki?)

	neg_shift: INTEGER_32 = 30
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_neg'.

	pos_shift: INTEGER_32 = 20
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_pos'.

	Mask_1: NATURAL_64 = 0xcb67b0c18fe14f4d
			-- Tempering bit-mask ("b" on wiki)

	matrix_a: NATURAL_64 = 0xfac1e8c56471d722
			-- 2nd value in the twist transformation matrix (see `Mag_1')

end
