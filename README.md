# tictactoe.erl

## Description

This is an implementation of the tic-tac-toe game (or Noughts and crosses, Xs and Os) in Erlang.

## Features

##### User interface
* CLI

##### Board size
* 3x3

##### Perfect computer player
* Never loses
* Wins as soon as possible

## Dependencies

##### Execution
* Erlang/OTP 17 Erts 6.4 (it may run on other versions too, this is the one used during development).

##### Testing
* EUnit

##### Others
* [Rebar3][rebar3] (as the build tool, included in the repository)

[rebar3]: https://github.com/rebar/rebar3

## Test

`./rebar3 eunit`

## Compile and run

`./rebar3 escriptize` will create a runnable escript in `_build/default/bin/tictactoe`

## Directories

`src` contains the source code that will get compiled.

`test` contains the tests for the source code.

`lib_test` contains libraries to be used during testing with EUnit. They will not be included in the compiled code.

`_build` will be created by *rebar3* when running the tests and compiling. It will contain the compiled code.

## Rebar3 caveats

Sometimes, when removing source code after compiling it, rebar3 does not remove the compiled code corresponding with it.
It may be necessary to do a `rm -rf _build` before trying to compile and run again.
