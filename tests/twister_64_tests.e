note
	description: "[
		Test the {TWISTER_64} class by creating an instance 
		`from_array' and comparing the result to values in
		a test file.

		The test files were produced by the the code developed
		by by Matsumot and Takuji and available at
		  http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/emt.html and
		  http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/emt64.html
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	TWISTER_64_TESTS

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
			twister_64
			twister_constrained
		end

feature -- Basic operations

	twister_64
			-- Compare first 1000 randoms to known values
		local
			rng: TWISTER_64
		do
				-- {NATURAL_64}
			create rng.from_array (init_array)
			divider (rng.generating_type + "  1000 {NATURAL_64} numbers")
			test_1000 (rng, directory + "mt19937-64.out")
				-- {REAL_64}
			create rng.from_array (init_array)
			divider (rng.generating_type + "  1000 {REAL_64} numbers")
			test_reals (rng, directory + "mt19937-64.out")
		end

	twister_constrained
			-- Check random generation in a restricted range
		local
			rng: TWISTER_64
		do
			create rng
			divider (rng.generating_type + " constrained")
			test_constrained (rng, 100, 150)
		end

feature {NONE} -- Implementation

	test_constrained (a_rng: TWISTER_64; a_lower, a_upper: NATURAL_64)
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

	test_1000 (a_rng: TWISTER_64; a_filename: STRING_8)
			-- Test the number generation for the first 1000 {NATURAL_64}
			-- numbers produced by a_rng against the values in the file
			-- named `a_filename'.
			-- This feature combined with the calling features `melg_607',
			-- `melg_1279', etc, test {TWISTER_64} features `initialize',
			-- `from_array', `twist', `forth', and `item'.
			-- Show the first 10 and the last 3 for visual confirmation.
		local
			f: PLAIN_TEXT_FILE
			env: EXECUTION_ENVIRONMENT
			s: STRING
			i: INTEGER
			n: NATURAL_64
			failed: BOOLEAN
		do
			create env
			s := env.current_working_path.out
			create f.make_open_read (a_filename)
			if not failed then
					-- Check the 1000 random numbers
				f.read_line
				check
					expected_line: f.last_string ~ "1000 outputs of genrand64_int64()"
						-- because that is what is in the file
				end
				io.put_string ("%T Checking first to 10th random number %N")
				from i := 1
				until i > 10
				loop
					f.read_natural_64
					n := f.last_natural_64
					if i > 1 then
						procedure (agent a_rng.forth, "forth")
					end
					function (agent a_rng.item, "item", n)
					i := i + 1
				end
				io.put_string ("%T Checking 11th through 996th random number...   %N")
				from
				until i > 997
				loop
					a_rng.forth
					f.read_natural_64
					n := f.last_natural_64
					assert ("item check: ", a_rng.item = n)
					i := i + 1
				end
				io.put_string ("%T Checking 998th to 1000th random number %N")
				from
				until i > 1000
				loop
					f.read_natural_64
					n := f.last_natural_64
					procedure (agent a_rng.forth, "forth")
					function (agent a_rng.item, "item", n)
					i := i + 1
				end
				f.close
			end
		end

	test_reals (a_rng: TWISTER_64; a_filename: STRING_8)
			-- Test the number generation for the first 1000 {REAL_64}
			-- numbers produced by a_rng against the values in the file
			-- named `a_filename'.
			-- This feature combined with the calling features `melg_607',
			-- `melg_1279', etc, test {TWISTER_64} features `initialize',
			-- `from_array', `twist', `forth', and `item'.
			-- Show the first 10 and the last 3 for visual confirmation.
		local
			f: PLAIN_TEXT_FILE
			env: EXECUTION_ENVIRONMENT
			s: STRING
			i: INTEGER
			r: REAL_64
			failed: BOOLEAN
		do
			create env
			s := env.current_working_path.out
			create f.make_open_read (a_filename)
			if not failed then
					-- Skip the text line
				f.read_line
				check
					expected_line: f.last_string ~ "1000 outputs of genrand64_int64()"
						-- because that is what is in the file
				end
					-- Skip the 1000 {NATURAL_64} values at beginning of file
					-- and advance the generator
				from i := 1
				until i > 1000
				loop
					f.read_natural_64
					if i > 1 then
						a_rng.forth
					end
					i := i + 1
				end
					-- Skip the blank line and text line
				f.read_line
				f.read_line
				f.read_line
--				io.put_string ("  after read_line   last_string = '" + f.last_string + "' %N")
				check
					expected_line: f.last_string ~ "1000 outputs of genrand64_real2()"
						-- because that is what is in the file
				end
				io.put_string ("  -- {REAL_64} checks use `very_close' from {SAFE_DOUBLE_MATH) --%N")
				io.put_string ("%T Checking first to 10th REAL random number %N")
				from i := 1
				until i > 10
				loop
					f.read_real_64
					r := f.last_real_64
					procedure (agent a_rng.forth, "forth")
					function (agent a_rng.real_item, "item", r)
					i := i + 1
				end
				io.put_string ("%T Checking 11th through 996th REAL random number...   %N")
				from
				until i > 997
				loop
					f.read_real_64
					r := f.last_real_64
					a_rng.forth
					assert ("item check: ", close_enough (a_rng.real_item, r))
					i := i + 1
				end
				io.put_string ("%T Checking 998th to 1000th REAL random number %N")
				from
				until i > 1000
				loop
					f.read_real_64
					r := f.last_real_64
					procedure (agent a_rng.forth, "forth")
					function (agent a_rng.real_item, "item", r)
					i := i + 1
				end
				f.close
			end
		end

feature {NONE} -- Implementation

	valid_types: ARRAYED_SET [TYPE [detachable ANY]]
			-- The type of the objects for which these tests are valid
			-- Usually redefine as a once ("OBJECT") feature and add a
			-- `generating_type' for each type of valid object.
		once ("OBJECT")
			Result := Precursor {JJ_TEST_FACILITIES}
			Result.extend ((create {TWISTER_64}).generating_type)
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
