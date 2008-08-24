USING: kernel math sequences arrays ;
IN: collatz

: next-number ( x -- y )
dup even? [ 2 / ] [ 3 * 1 + ] if ;

: collatz ( x -- seq )
dup [ next-number dup 1 > ] [ dup ] [ ] produce
swap suffix swap prefix ;

: collatz-length ( x -- y )
collatz length ;

: from-to ( x y -- seq )
over 1- - >array swap [ + ] curry map ;

: max-length ( x y -- z )
from-to [ collatz-length ] map supremum ;



USING: tools.test ;

[ 2 ] [ 4 next-number ] unit-test
[ 16 ] [ 5 next-number ] unit-test

[ { 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1 } ] [ 22 collatz ] unit-test

[ 16 ] [ 22 collatz-length ] unit-test

[ { 5 6 7 8 } ] [ 5 8 from-to ] unit-test

[ 20 ] [ 1 10 max-length ] unit-test
[ 125 ] [ 100 200 max-length ] unit-test
[ 174 ] [ 900 1000 max-length ] unit-test
