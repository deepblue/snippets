-module (collatz).
-export ([collatz/1]).
-include_lib("eunit/include/eunit.hrl").

next_number(X) when X rem 2 == 0 -> X div 2;
next_number(X) -> X*3+1.

collatz(N) when is_integer(N) -> collatz([N]);
collatz([]) -> [];
collatz([H|L]) when H == 1 -> lists:reverse([H|L]);
collatz([H|L]) -> collatz([next_number(H)] ++ [H|L]).

collatz_length(N) -> length(collatz(N)).

max_length(From, To) -> 
	lists:max([collatz_length(X) || X <- lists:seq(From, To)]).






next_number_test_() -> [ 
	?_assert(2 == next_number(4)),
	?_assert(16 == next_number(5))
].

collatz_test_() -> [
	?_assert([2,1] == collatz([1,2])),
	?_assert([1]   == collatz(1)),
	
	?_assert([2, 1] == collatz(2)),
	?_assert([22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1] == collatz(22)),

	?_assert(16 == collatz_length(22))	
].

max_length_test_() -> [
	?_assert(20  == max_length(1,10)),
	?_assert(125 == max_length(100,200)),
	?_assert(174 == max_length(900,1000))
].
