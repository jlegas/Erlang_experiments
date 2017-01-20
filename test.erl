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
%-export([reverse/1, duplicate/1, sum/1, number/1, nth/2, temp/1, area/2, square/1, circarea/1, product/2, exp/2, expon/2]).
-compile(export_all).


%return nth element of a list L
nth(1, L) -> hd(L);
nth(N, L) -> nth(N-1, tl(L)).


%return the number of elements in the list L
number([]) -> 0;
number(L) -> 1 + number(tl(L)).


%return the sum of all elements in the list of int L
sum([]) -> 0;
sum(L) -> hd(L) + sum(tl(L)).


%return a list where all elements are duplicated
duplicate([]) -> [];
duplicate(L) -> [hd(L),hd(L)|duplicate(tl(L))].


%returns element not in a list
notinlist(E, []) -> [E];
notinlist(E, L) ->  case E == hd(L) of
                   false -> notinlist(E, tl(L));
                   true -> []
                 end.

%return a list of unique elements in the list L
unique([]) -> [];
unique(L) -> notinlist(hd(L),tl(L)) ++ unique(tl(L)).


%return a list where the order of elements is reversed
reverse([]) -> [];
reverse(L) -> reverse(tl(L)) ++ [hd(L)].

%returns a list of a certain element repetitions from a list
repinlist(_, []) -> [];
repinlist(E, L) ->  case E == hd(L) of
                      true -> [E] ++ repinlist(E, tl(L));
                      false -> [] ++ repinlist(E, tl(L))
                    end.

%return a list containing lists of equal elements
%%pack([]) -> [];
%%pack(L) -> [repinlist(hd(unique(L)))|repinlist()]


%temperature conversion
temp(F) -> (F - 32) / 1.8.


area(A, B) -> A * B.

square(A) -> area(A, A).

circarea(R) -> math:pi() * square(R).

product(M, N) ->
  if
    M == 0 -> 0;
    true -> N + product(M-1, N)
  end.

%exponentials
exp(X, 0) -> 1;
exp(X, 1) -> X;
exp(X, Y) -> product(X, exp(X, Y-1)).

%exponentials
expon(X, Y) ->
  if
    Y == 0 -> 1;
    Y == 1 -> X;
    Y rem 2 == 0 -> square(expon(X, Y / 2));
    true -> expon(X, Y - 1) * X
  end.

%Insertion sort
insert(E, L) ->
if
  length(L) == 0 -> L = [E|[]];
  true -> L
end.




%%
%%isort(L) -> isort(L, ...).
%%isort(.., ...) ->
%%...;
%%isort(..., ...) ->
%%isort(..., ...).
%%insert(..., ...) ->
%%...;
%%insert(..., ...) ->
%%if
%%... -> ...;
%%true -> ...
%%end.


