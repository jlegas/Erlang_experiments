%%%-------------------------------------------------------------------
%%% @author justi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. jan 2017 19:57
%%%-------------------------------------------------------------------
-module(test).
-author("justi").

%% API
-export([temp/1, area/2, sqarea/1, circarea/1, product/2, exp/2, expon/2]).

temp(F) -> (F - 32) / 1.8.

area(A, B) -> A * B.

sqarea(A) -> area(A, A).

circarea(R) -> math:pi() * sqarea(R).

product(M, N) ->
  if
    M == 0 -> 0;
    true -> N + product(M-1, N)
  end.

exp(X, 0) -> 1;
exp(X, 1) -> X;
exp(X, Y) -> product(X, exp(X, Y-1)).

expon(X, Y) ->
  if
    Y == 0 -> 1;
    Y == 1 -> X;
    Y rem 2 == 0 -> sqarea(expon(X, Y / 2));
    true -> expon(X, Y - 1) * X
  end.

