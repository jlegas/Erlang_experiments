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

squarea(A) -> area(A, A).

circarea(R) -> math:pi() * R * R.

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
    Y rem 2 == 0 -> (expon(X, Y / 2)) * (expon(X, Y / 2));
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



%Merge sort
%
%main
msort([]) -> [];
msort([E]) -> [E];
msort(L) -> {Left, Right} = msplit(L, [], []), merge(msort(Left), msort(Right)).

%split list into two
msplit([], Left, Right) -> {Left, Right};
msplit(L, Left, Right) -> msplit(tl(L), [hd(L) | Right], Left).

%merge from smallest to largest, last case at one element left to merge
merge([E], Right) -> insert(E, Right);
merge(Left, [E]) -> insert(E, Left);
merge(Left, Right) -> if
                        hd(Left) =< hd(Right) -> [hd(Left) | merge(tl(Left),Right)];
                        true -> [hd(Right) | merge(Left, tl(Right))]
                      end.


%Quick sort
%
%main
qsort([]) -> [];
qsort([E]) -> [E];
qsort(L) -> {Left, Right} = qsplit(hd(L), tl(L), [], []),
SmallSorted = qsort(Left) ++ [hd(L)],
LargeSorted = qsort(Right),
append(SmallSorted, LargeSorted).

append(Left, Right) -> Left ++ Right.

%split the list using 1st element as a pivot
qsplit(_, [], Left, Right) -> {Left, Right};
qsplit(Pivot, ListTOSplit, Left, Right) -> if
                                             Pivot >= hd(ListTOSplit) -> qsplit(Pivot, tl(ListTOSplit), [hd(ListTOSplit) | Left], Right);
                                             true -> qsplit(Pivot, tl(ListTOSplit), Left, [hd(ListTOSplit) | Right])
                                           end.

%Benchmark
%shows the difference in performance between naive reversing of lists and accumulator assisted
%
%naive reverse
nreverse([]) -> [];
nreverse([H|T]) ->
  R = nreverse(T),
  append(R, [H]).

%Accumulated reverse
areverse(L) ->
  areverse(L, []).
areverse([], R) ->
  R;
areverse([H|T], R) ->
  areverse(T, [H|R]).

%Benchmark
bench() ->
  Ls = [16, 32, 64, 128, 256, 512],
  N = 10000,
  Bench = fun(L) ->
    S = lists:seq(1,L),
    Tn = time(N, fun() -> nreverse(S) end),
    Tr = time(N, fun() -> areverse(S) end),
    io:format("length: ~10w nrev: ~8w us arev: ~8w us~n", [L, Tn, Tr])
          end,
  lists:foreach(Bench, Ls).
time(N, F)->
%% time in micro seconds
  T1 = erlang:system_time(micro_seconds),
  loop(N, F),
  T2 = erlang:system_time(micro_seconds),
  (T2 -T1).
loop(N, Fun) ->
  if N == 0 -> ok; true -> Fun(), loop(N-1, Fun) end.


%Binary coding
%represents a decimal integer in binary format in 2 different ways
%bin(N) and bin2pow(N)
%
%Simple remainder division by 2 method
bin(0) -> [0];
bin(1) -> [1];
bin(N) -> bin(N div 2) ++ [N rem 2].

%Sum of powers of 2 method (inefficient)
bin2pow(0) -> 0;
bin2pow(1) -> 1;
bin2pow(N) -> list1and0(has2powers(N)).

%Lists
list1and0(L) -> list1and0(hd(L), L).
list1and0(-1, _) -> [];
list1and0(N, L) -> case notinlist(N, L) /= [] of
                     true -> [0 | list1and0(N - 1, L)];
                     false -> [1 | list1and0(N - 1, L)]
                   end.

%return a list of powers of 2 that sum up to the N
has2powers(0) -> [];
has2powers(1) -> [0];
has2powers(2) -> [1];
has2powers(N) ->
  [highest2pow(N) | has2powers(N - raise2toPow(highest2pow(N)))].

%return the highest power of 2 that is <= N
highest2pow(1) -> 0;
highest2pow(N) -> if
                    (N div 2) >= 1 -> 1 + (highest2pow(N div 2));
                    true -> 1
                  end.

%raises 2 to the power N
raise2toPow(0) -> 0;
raise2toPow(1) -> 2;
raise2toPow(N) -> 2 * raise2toPow(N - 1).



