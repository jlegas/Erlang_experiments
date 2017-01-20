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
-compile(export_all).


%return nth element of a list L
nth(1, L) -> hd(L);
nth(N, L) -> nth(N - 1, tl(L)).


%return the number of elements in the list L
number([]) -> 0;
number(L) -> 1 + number(tl(L)).


%return the sum of all elements in the list of int L
sum([]) -> 0;
sum(L) -> hd(L) + sum(tl(L)).


%return a list where all elements are duplicated
duplicate([]) -> [];
duplicate(L) -> [hd(L), hd(L) | duplicate(tl(L))].


%returns element if not in list
notinlist(E, []) -> [E];
notinlist(E, L) -> case E == hd(L) of
                     false -> notinlist(E, tl(L));
                     true -> []
                   end.

%return a list of unique elements in the list L
unique([]) -> [];
unique(L) -> notinlist(hd(L), tl(L)) ++ unique(tl(L)).


%return a list where the order of elements is reversed
reverse([]) -> [];
reverse(L) -> reverse(tl(L)) ++ [hd(L)].


%returns a list of a certain element repetitions from a list
repinlist(_, []) -> [];
repinlist(E, L) -> case E == hd(L) of
                     true -> [E] ++ repinlist(E, tl(L));
                     false -> [] ++ repinlist(E, tl(L))
                   end.

%iterates through items in a given list and return repetitions
iteraterep([], _) -> [];
iteraterep(UL, L) -> [repinlist(hd(UL), L) | iteraterep(tl(UL), L)].

%return a list containing lists of equal elements
pack([]) -> [];
pack(L) -> iteraterep(unique(L), L).


%temperature conversion
temp(F) -> (F - 32) / 1.8.


area(A, B) -> A * B.

square(A) -> area(A, A).

circarea(R) -> math:pi() * square(R).

product(M, N) ->
  if
    M == 0 -> 0;
    true -> N + product(M - 1, N)
  end.

%exponentials
exp(_, 0) -> 1;
exp(X, 1) -> X;
exp(X, Y) -> product(X, exp(X, Y - 1)).

%exponentials quicker
expon(X, Y) ->
  if
    Y == 0 -> 1;
    Y == 1 -> X;
    Y rem 2 == 0 -> square(expon(X, Y / 2));
    true -> expon(X, Y - 1) * X
  end.


%Insertion sort
%
%insert a specific element into a list
insert(E, []) -> [E];
insert(E, L) ->
  if
    hd(L) >= E -> [E | L];
    true -> [hd(L)|insert(E,tl(L))]
  end.

%insertion-sort a given array into a target array
isort([], _) -> [];
isort(List, Sorted) ->  insert(hd(List), isort(tl(List), Sorted)).

%final insertion-sort
isort(L) -> isort(L, []).



