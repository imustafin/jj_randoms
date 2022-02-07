note
	description: "[
		Defines constants for the {MELG_1279} Random Number Generator
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	MELG_1279_CONSTANTS

feature {NONE} -- Implementation

	nn: INTEGER_32 = 19
			-- Number of elements in the state array
			-- Degreed of recurrence (wiki)

	mm: INTEGER_32 = 7
			-- Offset bit for middle word, an offset used in the recurrence
			-- relation defining the series, 1 <= mm < nn

	p: INTEGER_32 = 63
			-- W - R, where R is the seperation point of a word

	Lag_1: INTEGER_32 = 5
			-- Tempering bit-shift value ("elle" on wiki)

	Shift_1: INTEGER_32 = 6
			-- Tempering bit-shift value ("s" on wiki?)

	neg_shift: INTEGER_32 = 22
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_neg'.

	pos_shift: INTEGER_32 = 37
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_pos'.

	Mask_1: NATURAL_64 = 0x3a23d78e8fb5e349
			-- Tempering bit-mask ("b" on wiki)

	matrix_a: NATURAL_64 = 0x1afefd1526d3952b
			-- 2nd value in the twist transformation matrix (see `Mag_1')

	jump_strings: ARRAY [STRING_8]
			-- Helper feature to ease the creation of `jump_chars'
			-- (See https://github.com/sharase/melg-64)
		do
			Result := <<
				"a4704d47efb161016e3736c80e933688017732e3ffc4115893",
				"8838ba22bb5cddf444d6f3fb8f3431c350ef813cceb90a9587",
				"b8e1626e74dc53831fba639564f313238548597b13bc13679e",
				"172cf95e9fabac836d6888253c34e4ac182c6779be5414e2cb",
				"1933412fcbdc47a055d72c339f5033276d8cc5b491ec343bbe",
				"7f5467cd6ed8e33b8f1305b10e3b134e67c62358665d196e5c",
				"2030a9e45ae42eab5e0c"
			>>
		end

end
