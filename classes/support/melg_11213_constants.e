note
	description: "[
		Defines constants for the {MELG_11213} Random Number Generator
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	MELG_11213_CONSTANTS

feature {NONE} -- Implementation

	nn: INTEGER_32 = 175
			-- Number of elements in the state array
			-- Degreed of recurrence (wiki)

	mm: INTEGER_32 = 45
			-- Offset bit for middle word, an offset used in the recurrence
			-- relation defining the series, 1 <= mm < nn

	p: INTEGER_32 = 13
			-- W - R, where R is the seperation point of a word

	Lag_1: INTEGER_32 = 4
			-- Tempering bit-shift value ("elle" on wiki)

	Shift_1: INTEGER_32 = 5
			-- Tempering bit-shift value ("s" on wiki?)

	neg_shift: INTEGER_32 = 33
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_neg'.

	pos_shift: INTEGER_32 = 13
			-- Bit-shift value anded with `lung' in `twist'
			-- when calling `mat_3_pos'.

	Mask_1: NATURAL_64 = 0xbd2d1251e589593f
			-- Tempering bit-mask ("b" on wiki)

	matrix_a: NATURAL_64 = 0xddbcd6e525e1c757
			-- 2nd value in the twist transformation matrix (see `Mag_1')

	jump_strings: ARRAY [STRING_8]
			-- Helper feature to ease the creation of `jump_chars'
			-- (See https://github.com/sharase/melg-64)
		do
			Result := <<
				"f455de2f54520b2dd8ce35d97fd8b50e4ef4f8776263cf2a26",
				"f392b0e71ad26509d8d20ada6ff2b026ca14e21cc91597f6af",
				"280a5e22ecde9f9e6653fedcba04c3ece760f941994129db87",
				"c28701d351c7d54c951a38c11490cea33913acd7e0d5960300",
				"69e553711ebd8ac376a32a080863759449d00326bfc085951a",
				"2014ed68db92fb6a0db234c6175dd7e38fc03352e91d9988a5",
				"6734941d00e65311c51f6358653537be02609619a45c1c3d12",
				"c257a1d559d4b485df547b60aff026ac32dcfa01f1e2d2105a",
				"d68e3a268c67594f8b90bee09fe3df899ce7c2f02eb05070d3",
				"707f50d2f6f8bd2864833733fd6505bd2d08deefccea8725c4",
				"7fd4febd22882362955bf5bd8a604118bc1ce86a8f9d0a76bc",
				"6f709cfb024f4d2c68a01777d344a10316999c02093f73e14f",
				"5cf573e4242e09ff6c154a77dc7796f812ee713886219caae3",
				"f3db710d37b215b79a49fbc6339eedcc63785fa5f96fbf0352",
				"13d4455545447e708d555f6b060c0fd27d713a0285bb7b1565",
				"6cc5bde689b6a61f5ab0140b4a7d2ed3b44ee302f9e21e747c",
				"9ed7d1d5005e72f00dc6a5e6264d44deff7fd1ed39fa33dde6",
				"11adf01d41e1241b9eed738b88c3280523126b6c5c16679cbf",
				"9aaf27e035bbc52449d4d7e2f129b18924549b731c7efd1c41",
				"20898ed1fe1f005db1160a6918c8b22823385aea6961f18487",
				"e3bfb3ec478ac6c9c5fe8b89f590cd59ddb4dec62ee27bc32d",
				"534566c4d4e9c8eb6989a74723b11baf1524db1ed389e8f245",
				"e97fd9322674e177e5e34eef5254aafac857351aa2a352f0d2",
				"128d4f97b6803e02031e25b5f51ba3f7cb1d789614d01d3a82",
				"7067c24deb627f8a84eee83dcff9ce5e5886981388ea4a8145",
				"2e6b68e05227585898f16ce6a163cfca9db2964ade5ffc7754",
				"88e48e9f1ea25afcdaf40745087fa358bacb25070a1a23b0ff",
				"7f67670327fd511a897ff2aa995c51f4218217d604495aed21",
				"3a99b36560444269159c1510083af95f2660abf69e311bed3d",
				"fd37177aac8784d12f1654d49197ba58b598f8bd0aea9711c6",
				"8bffded44acb765090baf2744e43fba03f80ed667e3880b2a4",
				"fe0a56b4c84b2ecdc76f2150615cf54ad6469e4fcf10ab3f20",
				"be5080409cc4325d67a91f535b2ed5c980f27142904ef64f5d",
				"e5bba1e5ef812c6802dc8671da7a60cd74c74277a19c01c917",
				"c275594677bee39ba5afbbf5ebfd7ac0c5cde0cf1c4df295d6",
				"ae684dc704937f930d3200f163d54760bdd961e96ffc64aae2",
				"d05f357362b29e0dda3e808366808aca5ff9c0391b7b00b9fc",
				"f923d7b5ebf3d876fb1ea6058febf4c65c5f925c6a8b7a2af3",
				"f32988838dbf961486f1805b68f7b53c74dabb57c89f0d4460",
				"6897da58f9967d79270678b7e0bebd9bbaa058152f17c7c0ee",
				"5fbf16ad091f19b744f11a980084b3a585682a413fe1b30aa5",
				"0f836e60c647fa9d27628e7a5abe87dbda4cd4c4ecc165cafb",
				"307ad89d35655188d77f1d5ef339a1b84cef2c5991a3078900",
				"dbeeb76b0516d27f22e98a4c0fb9282535d2a8afa7bd0b7ddc",
				"9c14b007eb5dc9bed6ef7fe875758977750d9f1420110c3804",
				"645c4524abe712a40c426d466096ca8ad26232c4441f1d2091",
				"3e1be38e0fbad2c67304d39ce9a5e130b06896c40348a52b32",
				"be85dcae102dd2b631301decf98b436a52891fac17bdca7e7a",
				"0f9e7a685fb8c1c58f2095c7e44c67cbe61ad1015947043d97",
				"bb9d9d40d5d54eba0f14383f6a16fce87e1d0719528c25c71b",
				"441672c77b0a4dfb081176ed7add6b804052de243b08b9ab30",
				"517c1ee135c7b3690b7805b0d2664cbba443d0bf61ca0b276b",
				"332b641579ca19de873a074e642eeb5cdb4a202bed3e0cb8fd",
				"1bfc313f5013fdb325e217790e418acb9da12088efb02ee740",
				"708c49f4136c8f31c60998c756c8af8537426dd25ae152e655",
				"27c66b475477fbabe007c9e65b91acceb9227d3baf24dccd8c",
				"18d0"
				>>
		end

end
