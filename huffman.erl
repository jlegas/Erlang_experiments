%%%-------------------------------------------------------------------
%%% @author justi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. jan 2017 21:21
%%%-------------------------------------------------------------------
-module(huffman).
-author("justi").

%% API
-compile(export_all).

sample() -> "the quick brown fox jumps over the lazy dog
this is a sample text that we will use when we build
up a table we will only handle lower case letters and
no punctuation symbols the frequency will of course not
represent english but it is probably not that far off".

text() -> "this is something that we should encode".

foo() -> "foofoofoobar".

test() ->
  Sample = sample(),
  Freq = freq(Sample),
  Tree = huffman(Freq),
  Encode = encode_table(Tree),
  Decode = decode_table(Tree),
  Text = text(),
  Seq = encode(Text, Encode),
  Text = decode(Seq, Decode).

%Huffman tree from sample text
tree(Sample) -> Freq = freq(Sample),
  huffman(Freq).

freq(Sample) -> freq(Sample, []).

freq([], Freq) ->
  Freq;
freq([Char | Rest], Freq) ->
  freq(Rest, update(Char, Freq)).

%make a list of tuples like [{$a, 1}, {..}..]
update(Char, []) ->
  [{Char, 1}];
update(Char, [{Char, N} | Freq]) ->
  [{Char, N + 1} | Freq];
update(Char, [Elem | Freq]) ->
  [Elem | update(Char, Freq)].

%building a tree
huffman(Freq) ->
  %sorting list of tuples by frequency
  Sorted = lists:sort(fun({_, F1}, {_, F2}) -> F1 < F2 end, Freq),
  huffman_tree(Sorted).

huffman_tree([{Tree, _}]) ->
  Tree;
huffman_tree([{A, Af}, {B, Bf} | Rest]) ->
  huffman_tree(insert({{A, B}, Af + Bf}, Rest)).

insert({A, Af}, []) ->
  [{A, Af}];
insert({A, Af}, [{B, Bf} | Rest]) when Af < Bf ->
  [{A, Af}, {B, Bf} | Rest];
insert({A, Af}, [{B, Bf} | Rest]) ->
  [{B, Bf} | insert({A, Af}, Rest)].


%Map characters to codes in Huffman tree
encode_table(Tree) ->
  codes(Tree, []).

%Map codes in Huffman tree to characters
decode_table(Tree) ->
  Tree.

codes({A, B}, Sofar) ->
  As = codes(A, [0 | Sofar]),
  Bs = codes(B, [1 | Sofar]),
  As ++ Bs;
codes(A, Code) ->
  [{A, lists:reverse(Code)}].


%encode text with a mapping, return sequence of bits
encode([], _Table) -> [];
encode([C | Rest], Table) ->
  {C, Code} = code_lookup(C, Table),
  Code ++ encode(Rest, Table).

code_lookup(C, Table) ->
  lists:keyfind(C, 1, Table).

decode(Seq, Tree) ->
  decode(Seq, Tree, Tree).


%Decode bit sequence by traversing the tree until char found
decode([], Char, _) -> [Char];
decode([0 | Seq], {Left, _}, Tree) ->
  decode(Seq, Left, Tree);
decode([1 | Seq], {_, Right}, Tree) ->
  decode(Seq, Right, Tree);
decode(Seq, Char, Tree) ->
  [Char | decode(Seq, Tree, Tree)].


read(File, N) ->
  {ok, Fd} = file:open(File, [read, binary]),
  {ok, Binary} = file:read(Fd, N),
  file:close(Fd),
  case unicode:characters_to_list(Binary, utf16) of
    {incomplete, List, _} ->
      List;
    List ->
      List
  end.


