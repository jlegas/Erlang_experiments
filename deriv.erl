%%%-------------------------------------------------------------------
%%% @author justi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. jan 2017 16:01
%%%-------------------------------------------------------------------
-module(deriv).
-author("justi").

%% API
-compile(export_all).



-type literal() :: {const, number()} | {const, atom()} | {var, atom()}.
-type expr() :: literal() | {mul, expr(), expr()} | {add, expr(), expr()}
| {exp, expr(), expr()} | {ln, expr()}
| {sqrt, expr()} | {sin, expr()} | {cos, expr()}.

deriv({const, _}, _) -> {const, 0};
deriv({var, V}, V) -> {const, 1};
%todo investigate this
deriv({var, Y}, _) ->
  {error, undefined_expression};
deriv({add, E1, E2}, V) ->
  {add, deriv(E1, V), deriv(E2, V)};
deriv({mul, E1, E2}, V) ->
  {add, {mul, deriv(E1, V), E2}, {mul, E1, deriv(E2, V)}};
deriv({exp, {var, V}, {const, N}}, V) ->
  {mul, {exp, {var, V}, {const, N -1}}, {const, N}};
deriv({exp, _, _}, _) ->
  {error, undefined_expression};
deriv({ln, {var, V}}, V) ->
  {exp, {var, V}, {const, -1}};
deriv({ln, _}, _) ->
  {error, undefined_expression};
deriv({sqrt, {var, V}}, V) ->
  deriv({exp, {var, V}, {const, 1/2}}, V);
deriv({sqrt, _}, _) ->
  {error, undefined_expression};
deriv({sin, {var, V}}, V) ->
  {cos, {var, V}};
deriv({sin, _}, _) ->
  {error, undefined_expression};
deriv(_, _) ->
  {error, undefined_expression}.
