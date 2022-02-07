note
	description: "[
		Defines constants for the {MELG_2281} Random Number Generator
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	MELG_2281_CONSTANTS

feature {NONE} -- Implementation

	nn: INTEGER_32 = 35
			-- Number of elements in the state array
			-- Degreed of recurrence (wiki)

	mm: INTEGER_32 = 17
			-- Offset bit for middle word, an offset used in the recurrence
			-- relation defining the series, 1 <= mm < nn

	p: INTEGER_32 = 41
			-- W - R, where R is the seperation point of a word

	Lag_1: INTEGER_32 = 6
			-- Tempering bit-shift value ("elle" on wiki)

	Shift_1: INTEGER_32 = 6
			-- Tempering bit-shift value ("s" on wiki?)

	neg_shift: INTEGER_32 = 36
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_neg'.

	pos_shift: INTEGER_32 = 21
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_pos'.

	Mask_1: NATURAL_64 = 0xe4e2242b6e15aebe
			-- Tempering bit-mask ("b" on wiki)

	matrix_a: NATURAL_64 = 0x7cbe23ebca8a6d36
			-- 2nd value in the twist transformation matrix (see `Mag_1')

	jump_strings: ARRAY [STRING_8]
			-- Helper feature to ease the creation of `jump_chars'
			-- (See https://github.com/sharase/melg-64)
		do
			Result := <<
				"153f3f5f58ab21e2b7e825fdc3cf74144f37d5320d6d4a08d4",
				"5b84ceb30294b6f66be04d2b9a7bd2fe0ffe28dfc60c814e82",
				"c4f85543a992fb7abf20f2f45c4b9e10729797ee8c34624102",
				"b21adc05b2abaf1e08bd353b30d2ee3b889f4df1209245d8f5",
				"4c836ee63466f0ed7bbf5816c6d3b36c9676b8a9d48f82a60a",
				"87d7d40a5da53a7fcf46ee5f3052bb8010509c9a550d29867c",
				"0f8d0b65ac69c69889d72ef9f7d782dacdb6d849a54d67c5d1",
				"98468a02b28eabac4fa905fb06a1c2cd8def5e9ee05da25d92",
				"be43269cddcd54a96543292fb854cd62a1d45c417f8666ef7c",
				"fa5404456991aec230fe92c6eb513151d9810de985906e49f6",
				"245bbcdcf257700469db91830d7e08dab027f5bb294962cf6b",
				"bb3b53f1c22932113a870"
				>>
		end

end
