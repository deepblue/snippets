#!/bin/sh

erlc collatz.erl
erl -noshell -s collatz test -s init stop