note
	description: "[
		Features usefull in test classes.  These features produce
		readable output.

		1) Inherit from this class and from {EQA_TEST_SET} then effect
		features to account for the type of objects to be tested.

		2) Call features `procedure', `function', or `predicate' passing
		an agent to the feature to be tested.
	]"
	author:    "Jimmy J. Johnson"
	date:      "2/6/22"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

deferred class
	JJ_TEST_FACILITIES

inherit

	EQA_TEST_SET

inherit {NONE}

	SAFE_DOUBLE_MATH
		undefine
			default_create
		end


feature -- Basic operations

	run_all
			-- Can be called by a demo program (as opposed to AutoTest)
			-- to produce output showing the called feature and outputs.
			-- Caveat:  if this feature is defined in an non-deferred class,
			-- AutoTest will call it as a test procedure.
			-- Therefore, it may be better to just call each concrete test
			-- procedure directly from the demo program.
		do
		end

feature {NONE} -- Implementation

	valid_types: ARRAYED_SET [TYPE [detachable ANY]]
			-- The type of the objects for which these tests are valid
			-- Usually redefine as a once ("OBJECT") feature and add a
			-- `generating_type' for each type of valid object as in:
			--     Result.extend ((create {MY_OBJECT}).generating_type)
		once ("OBJECT")
			create Result.make (10)
			Result.compare_objects
		end

	frozen is_valid_target_type (a_routine: ROUTINE): BOOLEAN
			-- Is the target of `a_routine' a type that this class can test?
		do
			check attached a_routine.target as t then
				Result := valid_types.has (t.generating_type)
			end
			if not Result then
					-- The check for attached like Current seems to handle the case where
					-- `a_routine' is referencing an attribute.  In that case, the actual
					-- target is the second argument of the `closed operands' not the first
					-- argument as I would expect.
				check attached {like Current} a_routine.target as t then
					check attached a_routine.closed_operands as args and then args.count >= 2 then
						check attached args[2] as a2 then
							Result := valid_types.has (a2.generating_type)
						end
					end
				end
			end

--			Result := attached a_routine.target as t and then
--				(attached {TWISTER_64} t or else
--					attached {TWISTER_32} t or else
--					attached {MELG} t)
--			if not Result then
--					-- The check for attached like Current seems to handle the case where
--					-- `a_routine' is referencing an attribute.  In that case, the actual
--					-- target is the second argument of the `closed operands' not the first
--					-- argument as I would expect.
--				check attached {like Current} a_routine.target as t then
--					check attached a_routine.closed_operands as args and then args.count >= 2 then
--					end
--				end
--			end
		end

	function (a_function: FUNCTION [TUPLE, ANY]; a_name: STRING_8; a_expected: ANY)
			-- Execute `a_function', printing the `signature' of the call
			-- and asserting that the result of the call is equivalent
			-- to `a_expected'.
		require
			target_closed: attached a_function.target
			no_open_arguments: a_function.open_count = 0
			expected_types: is_valid_target_type (a_function)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_function, a_name)
			ans := a_function.item (a_function.operands)
			if attached {REAL_64} ans as a then
				if attached {REAL_64} a_expected as e then
					is_ok := close_enough_with_tolerance (a, e, 0.0000001)
				end
			elseif attached {REAL_32} ans as a then
				if attached {REAL_32} a_expected as e then
					is_ok := close_enough (a, e)
				end
			else
				is_ok := ans.out ~ a_expected.out
			end
			s := s + " ==> " + as_named (ans)
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	predicate (a_predicate: PREDICATE; a_name: STRING_8; a_expected: BOOLEAN)
			-- Execute `a_function', printing the `signature' of the call
			-- and asserting that the result of the call is equivalent
			-- to `a_expected'.
		require
			target_closed: attached a_predicate.target
			no_open_arguments: a_predicate.open_count = 0
			expected_types: is_valid_target_type (a_predicate)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_predicate, a_name)
			ans := a_predicate.item (a_predicate.operands)
			is_ok := ans.out ~ a_expected.out
			s := s + " ==> " + as_named (ans)
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	procedure (a_procedure: PROCEDURE; a_name: STRING_8)
			-- Execute `a_procedure', printing the `signature' of the call.
		require
			target_closed: attached a_procedure.target
			no_open_arguments: a_procedure.open_count = 0
			expected_types: is_valid_target_type (a_procedure)
		local
			s: STRING_8
		do
			s := signature (a_procedure, a_name)
			a_procedure.call
			io.put_string (s + "%N")
		end

	execute (a_routine: ROUTINE;
		a_name: STRING_8; a_expected: ANY)
			-- execute `a_routine' and output the `signature' of the call.
			-- If `a_routine' is a function, assert the result of the call
			-- is equivalent to `a_expected'.
		require
			target_closed: attached a_routine.target
			no_open_arguments: a_routine.open_count = 0
			expected_types: is_valid_target_type (a_routine)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_routine, a_name)
			if attached {PROCEDURE} a_routine as p then
				p.call
				is_ok := true
			elseif attached {PREDICATE} a_routine as p then
				ans := p.item (p.operands)
				is_ok := ans.out ~ a_expected.out
				s := s + " ==> " + as_named (ans)
			elseif attached {FUNCTION [TUPLE, ANY]} a_routine as f then
				ans := f.item (f.operands)
				is_ok := ans.out ~ a_expected.out
				s := s + " ==> " + as_named (ans)
			else
				check
					should_not_happen: False
					-- because `a_routine' is a {PROCEDURE} or a {FUNCTION}
				end
				ans := " should_not_happen "
			end
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	signature (a_routine: ROUTINE; a_feature: STRING): STRING
			-- Create a string representing a feature's signature.
		require
			target_closed: attached a_routine.target
			no_open_arguments: a_routine.open_count = 0
			expected_types: is_valid_target_type (a_routine)
		local
			i: INTEGER
			a: detachable ANY
			c: INTEGER  -- temp for testing
		do
			Result := ""
			check attached a_routine.target as t and attached a_routine.closed_operands as args then
				if attached {like Current} t then
						-- This must be a agent for an attribute
					check args.count >= 2 and then attached args [2] as a2 then
--						Result := Result + a2.generating_type + ":  "
						Result := Result + "(" + as_named (args [2]) + ")." + a_feature
						if args.count >= 3 then
							Result := Result + "("
							from i := 3
							until i > args.count
							loop
								a := args [i]
								Result := Result + as_named (a)
								if i < args.count then
									Result := Result + ", "
								end
								i := i + 1
							end
							Result := Result + ")"
						end
					end
				else
--					Result := t.generating_type.out + ":  "
					Result := Result + "(" + as_named (t) + ")." + a_feature
					c := args.count
					if args.count >= 2 then
						Result := Result + " ("
						from i := 2
						until i > args.count
						loop
							a := args [i]
							Result := Result + as_named (a)
							if i < args.count then
								Result := Result + ", "
							end
							i := i + 1
						end
						Result := Result + ")"
					end
				end
			end
		end

	as_named (a_any: detachable ANY): STRING_8
		local
			i: INTEGER
		do
			Result := ""
			if attached {TWISTER_32} a_any as t then
				Result := Result + t.generating_type
			elseif attached {TWISTER_64} a_any as t64 then
				Result := Result + t64.generating_type
			elseif attached {MELG} a_any as m then
				Result := Result + m.generating_type
			elseif attached {ARRAY [ANY]} a_any as a then
				from i := 1
				until i > a.count
				loop
					Result := Result + as_named (a[i])
					if i < a.count then
						Result := Result + ","
					end
					i := i + 1
				end
			elseif attached {SPECIAL [ANY]} a_any as a then
				from i := 1
				until i > a.count
				loop
					Result := Result + as_named (a[i])
					if i < a.count then
						Result := Result + ","
					end
					i := i + 1
				end
			elseif attached {NATURAL_64} a_any as n64 then
				Result := Result + n64.out
			elseif attached {NATURAL_32} a_any as n32 then
				Result := Result + n32.out
			elseif attached a_any then
				Result := Result + a_any.out
			else
				Result := "Void"
			end
		end

	divider (a_string: STRING_8)
			-- Print a dividing line containing `a_string'
			-- (e.g.  "----------- a_string ------------"
		local
			w, c, n, i: INTEGER_32
		do
			io.put_string ("%N%N%N")
			w := 70
			c := a_string.count
			n := (w - c) // 2
			from i := 1
			until i > n
			loop
				io.put_string ("-")
				i := i + 1
			end
			io.put_string (" " + a_string + " ")
			from i := 1
			until i > n
			loop
				io.put_string ("-")
				i := i + 1
			end
			io.put_string ("%N")
		end

end
