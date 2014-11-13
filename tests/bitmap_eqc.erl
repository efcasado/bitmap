%%%========================================================================
%%% File: bitmap_eqc.erl
%%%
%%% Erlang QuickCheck tests for the bitmap module.
%%%
%%% Author: Enrique Fernandez <efcasado@gmail.com>
%%%
%%%-- LICENSE -------------------------------------------------------------
%%% The MIT License (MIT)
%%%
%%% Copyright (c) 2014 Enrique Fernandez
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining
%%% a copy of this software and associated documentation files (the
%%% "Software"), to deal in the Software without restriction, including
%%% without limitation the rights to use, copy, modify, merge, publish,
%%% distribute, sublicense, and/or sell copies of the Software,
%%% and to permit persons to whom the Software is furnished to do so,
%%% subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included
%%% in all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%%% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
%%% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
%%% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
%%% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
%%% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
%%% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%========================================================================
-module(bitmap_eqc).

-include_lib("eqc/include/eqc.hrl").

-compile(export_all).



%% ========================================================================
%%  Generators
%% ========================================================================

bitmap() ->
    ?SUCHTHAT(BitMap, bitstring(), BitMap /= <<>>).

size() ->
    ?SUCHTHAT(Size, int(), Size > 0).

idx(Size) ->
    eqc_gen:choose(1, Size).

idxs(Size) ->
    ?LET(Idxs, list(idx(Size)), lists:usort(Idxs)).


%% ========================================================================
%%  Properties
%% ========================================================================

prop_new() ->
    ?FORALL(Size, size(),
    ?FORALL(Idxs, idxs(Size),
            lists:all(fun(0) -> true;
                         (1) -> true
                      end,
                      bitmap:idxs(Idxs, bitmap:new(Idxs, Size))))).

prop_list() ->
    ?FORALL(BitMap, bitmap(),
            BitMap == bitmap:from_list(bitmap:to_list(BitMap))).
