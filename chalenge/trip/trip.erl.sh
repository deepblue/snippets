#!/bin/sh

erlc trip.erl
erl -noshell -s trip test -s init stop