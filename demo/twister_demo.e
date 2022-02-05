note
	description: "[
		Demonstrates and tests the 64-bit Mersenne Twister classes
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	TWISTER_DEMO

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			clear_screen
			show_introduction
			create melg_tests
			melg_tests.run_all
		end

feature -- Basic operations


feature -- Implementation

	clear_screen
			-- Scroll the terminal to clear the screen
		local
			i: INTEGER
		do
			from i := 1
			until i > 50
			loop
				print ("%N")
				i := i + 1
			end
		end

	show_introduction
			-- Display a message describing the intent of this demo
		do
			print ("This program tests the 64-bit Random Number Generator classes %N")
			print ("(e.g. TWISTER_64 and {MELG} and its desendents), showing names %N")
			print ("of the called features and the result of those calls.  As the  %N")
			print ("calls execute, AutoTest %"assert%" checking confirms the accuracy %N")
			print ("of the features.  This class is actually calling test features   %N")
			print ("that are executable in AutoTest. %N")
			print ("%N")
		end

feature {NONE} -- Implementation

	melg_tests: MELG_TESTS
			-- An improved 64-bit Mersenne Twister RNG

end
