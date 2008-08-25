#!/bin/sh

erlc jolly.erl
erl -noshell -s jolly test -s init stop