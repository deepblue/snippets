-module (trip).
-export ([minimum_transfer/1]).
-include_lib("eunit/include/eunit.hrl").

init(X) -> lists:sort( fun(A,B) -> A>B end,
  lists:map( fun(N) -> trunc(N*100) end, X) ).
  
to_pay(X) -> 
  Avr = lists:sum(X) div length(X),
  Rem = lists:sum(X) rem length(X),
  lists:duplicate(Rem, Avr + 1) ++ lists:duplicate(length(X) - Rem, Avr).
  
subtract(A, B) -> subtract(A, B, []).
subtract([A|H], [B|T], L) -> subtract(H, T, L ++ [abs(A-B)]);
subtract([], [], L) -> L.

minimum_transfer(X) -> Input = init(X),
  lists:sum(subtract(Input, to_pay(Input))) / 200.0.
  

init_test_() -> [
  ?_assert([3000, 2000, 1000] == init([10.00, 20.00, 30.00]))
].

to_pay_test_() -> [
  ?_assert([2000, 2000, 2000] == to_pay([1000, 2000, 3000])),
  ?_assert([901, 901, 900, 900] == to_pay([1501, 1500, 301, 300]))
].

subtract_test_() -> [
  ?_assert([1,2,3] == subtract([5,4,3], [4,6,6]))
].

minimun_transfer_test_() -> [
  ?_assert(10.00 == minimum_transfer([10.00, 20.00, 30.00])),
  ?_assert(11.99 == minimum_transfer([15.00, 15.01, 3.00, 3.01]))  
].