USING: kernel math sequences arrays sorting math.vectors ;
IN: trip

: normalize-input ( seq -- seq )
  [ 100 * >integer ] map natural-sort reverse ;

! y개의 1로 이뤄진 길이 x의 array를 만든다
: (bit-array) ( x y -- seq )
  1 <array> swap 0 pad-right ;

: to-pay ( seq -- seq )
  [ sum ] [ length ] bi [ /mod ] keep
  rot [ <array> ] 2keep
  drop rot (bit-array)
  v+ ;

: minimum_transfer ( seq -- x )
  normalize-input [ to-pay ] keep v-
  [ abs ] map sum 200.0 / ;


USING: tools.test ;

[ { 3000 2000 1000 } ] [ { 10.00 20.00 30.00 } normalize-input ] unit-test
[ { 1 1 0 0 } ] [ 4 2 (bit-array) ] unit-test

[ { 2000 2000 2000 } ] [ { 3000 2000 1000 } to-pay ] unit-test
[ { 901 901 900 900 } ] [ { 1501 1500 301 300 } to-pay ] unit-test

[ 10.00 ] [ { 10.00 20.00 30.00 }     minimum_transfer ] unit-test
[ 11.99 ] [ { 15.00 15.01 3.00 3.01 } minimum_transfer ] unit-test