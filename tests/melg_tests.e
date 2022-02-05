note
	description: "[
		Test the {MELG} classes by creating an instance of
		each descendant `from_array' and comparing the result
		to values in the appropriate test file.

		The test files were produced by the the code developed
		by Shin Harase and Takamitsu Kimoto and available at
		https://github.com/sharase/melg-64.

		Only the first 1000 numbers are checked, becasue the
		"melg_jump"	method was not implemented in {MELG}.
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	MELG_TESTS

inherit

	JJ_TEST_FACILITIES
		redefine
			run_all,
			valid_types
		end

feature -- Basic operations

	run_all
			-- Run all the test features
		do
				-- 'from_array, etc.
--			twister_64

			melg_607
			melg_1279
			melg_2281
			melg_4253
			melg_11213
			melg_19937
			melg_44497
				-- with constraints
			twister_constrained
			melg_607_constrained
			melg_4253_constrained
			melg_19937_constrained
				-- check real intervals
			melg_19937_interval
		end

feature -- Basic operations

	twister_64
			-- Compare first 1000 randoms to known values
		local
			rng: TWISTER_64
		do
			create rng.from_array (init_array)
			divider (rng.generating_type)
			test_1000 (rng, directory + "mt19937-64.out")
		end

	melg_607
			-- Compare first 1000 randoms to known values
		local
			rng: MELG_607
		do
			create rng.from_array (init_array)
			divider (rng.generating_type)
			test_1000 (rng, directory + "melg607-64.out")
		end

	melg_1279
			-- Compare first 1000 randoms to known values
		local
			rng: MELG_1279
		do
			create rng.from_array (init_array)
			divider (rng.generating_type)
			test_1000 (rng, directory + "melg1279-64.out")
		end

	melg_2281
			-- Compare first 1000 randoms to known values
		local
			rng: MELG_2281
		do
			create rng.from_array (init_array)
			divider (rng.generating_type)
			test_1000 (rng, directory + "melg2281-64.out")
		end

	melg_4253
			-- Compare first 1000 randoms to known values
		local
			rng: MELG_4253
		do
			create rng.from_array (init_array)
			divider (rng.generating_type)
			test_1000 (rng, directory + "melg4253-64.out")
		end

	melg_11213
			-- Compare first 1000 randoms to known values
		local
			rng: MELG_11213
		do
			create rng.from_array (init_array)
			divider (rng.generating_type)
			test_1000 (rng, directory + "melg11213-64.out")
		end

	melg_19937
			-- Compare first 1000 randoms to known values
		local
			rng: MELG_19937
		do
			create rng.from_array (init_array)
			divider (rng.generating_type)
			test_1000 (rng, directory + "melg19937-64.out")
		end

	melg_44497
			-- Compare first 1000 randoms to known values
		local
			rng: MELG_44497
		do
			create rng.from_array (init_array)
			divider (rng.generating_type)
			test_1000 (rng, directory + "melg44497-64.out")
		end

feature -- Basic operations

	twister_constrained
			-- Check random generation in a restricted range
		local
			rng: TWISTER_64
		do
			create rng
			divider (rng.generating_type + " constrained")
			test_constrained (rng, 100, 150)
		end

	melg_607_constrained
			-- Check random generation in a restricted range
		local
			rng: MELG_607
		do
			create rng
			divider (rng.generating_type + " constrained to low range")
			test_constrained (rng, 0, 50)
		end

	melg_4253_constrained
			-- Check random generation in a restricted range
		local
			rng: MELG_4253
		do
			create rng
			divider (rng.generating_type + " constrained to high range")
			test_constrained (rng, rng.upper - 50, rng.upper)
		end

	melg_19937_constrained
			-- Check random generation in a restricted range
		local
			rng: MELG_19937
		do
			create rng
			divider (rng.generating_type + " constrained to mid range")
			test_constrained (rng, rng.upper // 2, rng.upper // 2 + 50)
		end

feature -- Basic operations

	check_closed_interval (a_rng: MELG)
			-- Call `real_item' until getting a random that is
			-- `very_close' (see {SAFE_DOUBLE_MATH} class) to Zero,
			-- and then until getting `very_close' to One.
			-- It took 55,340,000 tries to get `close_enough' to
			-- Zero (6.2888154683804487e-09) and `close_enough' to
			-- a One (0.99999999467907086).
			-- I don't know why `very_close' produced the same.
		local
--			i, c, zc, oc: INTEGER_32
--			z, o: REAL_64
--			zero_found, one_found: BOOLEAN
		do
			divider (a_rng.generating_type + ":  check_closed_interval")
			io.put_string ("   Commented out, because takes too long %N")
--			from i :=1
--			until zero_found and one_found
--			loop
--				if i = 1_000_000 then
--					io.put_string (".")
--					c := c + 1
--					i := 1
--				else
--					i := i + 1
--				end
--				if very_close (a_rng.real_item, 0.0) then
--					zero_found := true
--					z := a_rng.real_item
--				end
--				if very_close (a_rng.real_item, 1.0) then
--					one_found := true
--					o := a_rng.real_item
--				end
--				a_rng.forth
--			end
--			io.put_string ("After " + c.out + " * 1,000,000 + " + i.out + " tries: %N")
--			io.put_string ("Zero value = " + z.out + "    One value = " + o.out + "%N")
		end

	melg_19937_interval
			-- Check call to `real_item' to determine if it ever
			-- returns a One and/or a Zero.
		local
			rng: MELG_19937
		do
			create rng
			check_closed_interval (rng)
		end

feature {NONE} -- Implementation

	test_constrained (a_rng: MELG; a_lower, a_upper: NATURAL_64)
			-- Test and display information when `a_rng' `is_constrained'
			-- between `a_lower' and `a_upper'
		local
			i: INTEGER_32
			n: NATURAL_64
			c: INTEGER_32
			hist: HASH_TABLE [INTEGER_32, NATURAL_64]	-- [count, key]
				-- Used HASH_TABLE instead of ARRAY, because the index to
				-- an ARRAY must be an INTEGER, but need NATURAL_64.
		do
			predicate (agent a_rng.is_constrained, "is_constrained", False)
			procedure (agent a_rng.set_range (a_lower, a_upper), "set_range")
			predicate (agent a_rng.is_constrained, "is_constrained", True)
			function (agent a_rng.lower, "lower", a_rng.lower)
			function (agent a_rng.upper, "upper", a_rng.upper)
				-- Build a histogram
			create hist.make ((a_upper - a_lower).as_integer_32 * 2)
			from
				i := 1
			until i > Constrained_count
			loop
				hist[a_rng.item] := hist[a_rng.item] + 1
				a_rng.forth
				i := i + 1
				n := n + 1
			end
				-- Display the histogram
			from
				n := a_rng.lower
			until n > a_rng.upper or n < a_rng.lower	-- to catch wrap-aroud
			loop
				c := hist.definite_item (n)
				io.put_string (n.out + "  ==>  ")
				io.put_string (c.out + "%T")
				from i := 1
				until i > c
				loop
					io.put_string ("*")
					i := i + 1
				end
				io.put_string ("%N")
				n := n + 1
			end
		end

	test_1000 (a_rng: MELG; a_filename: STRING_8)
			-- Test the number generation for the first 1000 numbers
			-- produced by a_rng against the values in the file
			-- named `a_filename'.
			-- This feature combined with the calling features `melg_607',
			-- `melg_1279', etc, test {MELG} features `initialize',
			-- `from_array', `twist', `forth', and `item'.
			-- Show the first 10 and the last 3 for visual confirmation.
		local
			f: PLAIN_TEXT_FILE
			env: EXECUTION_ENVIRONMENT
			s: STRING
			i: INTEGER
			n: NATURAL_64
			r: REAL_64
			failed: BOOLEAN
		do
			create env
			s := env.current_working_path.out
			create f.make_open_read (a_filename)
			if not failed then
					-- Check the 1000 random numbers
				f.read_line
--				check
--					expected_line: f.last_string ~ "1000 outputs of genrand64_int64()"
--						-- because that is what is in the file
--				end
				io.put_string ("%T Checking first to 10th random number %N")
				from i := 1
				until i > 10
				loop
					f.read_natural_64
					n := f.last_natural_64
					function (agent a_rng.item, "item", n)
					procedure (agent a_rng.forth, "forth")
					i := i + 1
				end
				io.put_string ("%T Checking 11th through 996th random number...   %N")
				from
				until i > 997
				loop
					f.read_natural_64
					n := f.last_natural_64
					assert ("item check: ", a_rng.item = n)
					a_rng.forth
					i := i + 1
				end
				io.put_string ("%T Checking 998th to 1000th random number %N")
				from
				until i > 1000
				loop
					f.read_natural_64
					n := f.last_natural_64
					function (agent a_rng.item, "item", n)
					procedure (agent a_rng.forth, "forth")
					i := i + 1
				end
				---------------------------------------------------------
					-- Check the 1000 REAL random numbers					
				f.read_line
				f.read_line
				f.read_line
--				io.put_string ("  after read_line   last_string = '" + f.last_string + "' %N")
--				check
--					expected_line: f.last_string ~ "1000 outputs of genrand64_res53()"
--						-- because that is what is in the file
--				end
				io.put_string ("%N")
				io.put_string ("  -- {REAL_64} checks use `very_close' from {SAFE_DOUBLE_MATH) --%N")
				io.put_string ("%T Checking first to 10th REAL random number %N")
				from i := 1
				until i > 10
				loop
					f.read_real_64
					r := f.last_real_64
					function (agent a_rng.real_item, "item", r)
					procedure (agent a_rng.forth, "forth")
					i := i + 1
				end
				io.put_string ("%T Checking 11th through 996th REAL random number...   %N")
				from
				until i > 997
				loop
					f.read_real_64
					r := f.last_real_64
					assert ("item check: ", close_enough (a_rng.real_item, r))
					a_rng.forth
					i := i + 1
				end
				io.put_string ("%T Checking 998th to 1000th REAL random number %N")
				from
				until i > 1000
				loop
					f.read_real_64
					r := f.last_real_64
					function (agent a_rng.real_item, "item", r)
					procedure (agent a_rng.forth, "forth")
					i := i + 1
				end
				f.close
			else
				io.put_string ("Ensure the file named " + a_filename + "is in %N")
				io.put_string ("the test directory and set the execution location %N")
				io.put_string ("to ../tests/ %N")
			end
		rescue
			failed := true
			retry
		end

feature {NONE} -- Implementation

	valid_types: ARRAYED_SET [TYPE [detachable ANY]]
			-- The type of the objects for which these tests are valid
			-- Usually redefine as a once ("OBJECT") feature and add a
			-- `generating_type' for each type of valid object.
		once ("OBJECT")
			Result := Precursor {JJ_TEST_FACILITIES}
			Result.extend ((create {TWISTER_64}).generating_type)
			Result.extend ((create {MELG_607}).generating_type)
			Result.extend ((create {MELG_1279}).generating_type)
			Result.extend ((create {MELG_2281}).generating_type)
			Result.extend ((create {MELG_4253}).generating_type)
			Result.extend ((create {MELG_11213}).generating_type)
			Result.extend ((create {MELG_19937}).generating_type)
			Result.extend ((create {MELG_44497}).generating_type)
		end

	init_array: ARRAY [NATURAL_64]
			-- Array used in 32-bit generators in `from_array'.
		once
			Result :=  {ARRAY [NATURAL_64]} <<0x12345, 0x23456, 0x34567, 0x45678>>
		end

	directory: STRING = "../tests/"
			-- Name of the file to test against in `from_array'

	Constrained_count: INTEGER_32 = 3000
			-- Number of radoms to generate for the `test_constrained' feature

end
