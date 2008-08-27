#!/bin/sh

erlc hello.erl
erl -noshell -s hello start -s init stop