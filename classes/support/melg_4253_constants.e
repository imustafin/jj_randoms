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

	jump_strings: ARRAY [STRING_8]
			-- Helper feature to ease the creation of `jump_chars'
			-- (See https://github.com/sharase/melg-64)
		do
			Result := <<
				"514609396aa32e1815afd614eabdd3ebacb4868f08cfed4ca1",
				"e27c40ed5a24db338fe372795db756f0f632ce67327a5e61e5",
				"53e9248920f860bf759719e5db8ace1d5334763fa5df0e92dc",
				"9e78719aae25aa0e8125b0a63fc035b9605c185a4fe35cc18f",
				"98210fb398dc6cd68932a6c4dead9efd6f410086ccbe8d2518",
				"9be700ed70bd07af780e7cbda0172647d929221aec90cd5bc7",
				"1d52b673c34edf12ab6fa5b72cb466b514dec1695e3aafbc15",
				"6e1a4c7d289d7644359e108ccad0247e120f3ca0d7d5007776",
				"f2df463f383eaa3abe97e4248764e79e8219ac22b00c622376",
				"d0d17dcb3d280de5e87c3b0b826a65c36c84704026ef8351df",
				"3e7f428d113311ae397d20fe518709867ae8f076ae58cf2498",
				"945fa9fc5dfa12d6db79078d3ad42c07655feb5a7846af5d6d",
				"1422db5ae9dcc999418ac24a1f4e4c2145fa7a7c74631de210",
				"6b284f0f26377cca29a1740104cdb723b8c907d50204da74d2",
				"d3ebe9fa9eed13e21ed507151567b864798ac67aa55dec472f",
				"2907042795f242448c0b9772d51b18fd7ce9b2eed2effbd069",
				"417d2d1ea1b14d2b5753d3a11295aa1de6b0d9e7172646c86f",
				"610133672dd7a1014e2916c5dbdff1040034e07d52e90edb36",
				"59e7b612a1c45d49280072c8da8a0f5e5497d8eebde67d6a9a",
				"1b29375720036d84245ff9b96c670c555610f35ed15889e97a",
				"cc8a7812be1fd09440714e353d1c197a9addf30acc7a0bc90f",
				"b1e354125eb388"
				>>
		end

end
