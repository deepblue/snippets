-module (jolly).
-include_lib("eunit/include/eunit.hrl").

% from trip.erl
subtract(A, B) -> subtract(A, B, []).
subtract([A|H], [B|T], L) -> subtract(H, T, L ++ [abs(A-B)]);
subtract([], [], L) -> L.

differences(A) ->
  List1 = lists:sublist(A, length(A)-1),
  List2 = lists:sublist(A, 2, length(A)),
  subtract(List1, List2).
  
is_jolly(L) ->
  lists:sort(differences(L)) == lists:seq(1, length(L)-1).
  
  
differences_test_() -> [
  ?_assert([3,2,1] == differences([1,4,2,3]))
].

minimum_transfer_test_() -> [
  ?_assert(true == is_jolly([1, 4, 2, 3])),
  ?_assert(false == is_jolly([1, 4, 2, -1, 6]))
].