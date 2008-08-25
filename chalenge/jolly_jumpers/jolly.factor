USING: kernel sequences arrays math math.vectors sorting ;
IN: jolly

: differences ( seq -- new-seq )
  [ but-last ] keep rest v- [ abs ] map ;

: jolly? ( seq -- ? )
  differences natural-sort 
  [ length >array [ 1+ ] map ] keep 
  = ;

USING: tools.test ;

[ { 3 2 1 } ] [ { 1 4 2 3 } differences ] unit-test

[ t ] [ { 1 4 2 3 } jolly? ] unit-test
[ t ] [ { 3 -1 -3 -2 } jolly? ] unit-test
[ f ] [ { 1 4 2 -1 6 } jolly? ] unit-test

