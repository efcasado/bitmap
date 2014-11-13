%%%========================================================================
%%% File: bitmap.erl
%%%
%%% A bitmap is a non-empty bitstring. This module features a set of
%%% functions for operating on bitmaps.
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
-module(bitmap).

-export(
   [
    new/2,
    idxs/2,
    to_list/1,
    from_list/1
   ]).

%% ========================================================================
%%  Type definitions
%% ========================================================================

-type bit() :: 0..1.



%% ========================================================================
%%  API
%% ========================================================================

%%-------------------------------------------------------------------------
%% @doc
%% Create a new bitmap of the specified size. All bits indexed at the
%% specified positions are set to 1 (all other bits are set to 0). The size
%% of the bitmap must be a positive integer (empty bitmaps are not
%% supported). The list of indexed bits must be sorted in ascending order
%% and no index can be greater than the size of the bitmap. Note that
%% bitmaps use one-based indexes.
%% @end
%%-------------------------------------------------------------------------
-spec new(list(pos_integer()), pos_integer()) -> bitstring().
new(Idxs, Size) when Size > 0 ->
    '_new'(Idxs, 0, Size, <<>>).

'_new'(_Vsns, Cnt, Size, BitMap) when Cnt =:= Size ->
    BitMap;
'_new'([], Cnt, Size, BitMap) ->
    lists:foldl(fun(_, Acc) ->
                        <<0:1, Acc/bits>>
                end,
                BitMap,
                lists:duplicate(Size - Cnt, 0));
'_new'([V| Vsns], Cnt, Size, BitMap) when (Cnt + 1) =:= V ->
    '_new'(Vsns, Cnt + 1, Size, <<1:1, BitMap/bits>>);
'_new'(Vsns, Cnt, Size, BitMap) ->
    '_new'(Vsns, Cnt + 1, Size, <<0:1, BitMap/bits>>).

%%-------------------------------------------------------------------------
%% @doc
%% Return the bit value for the specified indexes.
%% @end
%%-------------------------------------------------------------------------
-spec idxs(list(pos_integer()), bitstring()) -> list(bit()).
idxs(Idxs, BitMap) ->
    '_idxs'(lists:reverse(Idxs), BitMap, {bit_size(BitMap), []}).

'_idxs'([], <<>>, {_Cnt, Bits}) ->
    Bits;
'_idxs'([], _BitMap, {_Cnt, Bits}) ->
    Bits;
'_idxs'([I| Idxs], <<H:1, T/bitstring>>, {Cnt, Bits}) when Cnt =:= I->
    '_idxs'(Idxs, T, {Cnt - 1, [H| Bits]});
'_idxs'(Idxs, <<_H:1, T/bitstring>>, {Cnt, Bits}) ->
    '_idxs'(Idxs, T, {Cnt - 1, Bits}).



%%-------------------------------------------------------------------------
%% @doc
%% Convert the provided bitmap into a list of ones and zeros.
%% @end
%%-------------------------------------------------------------------------
-spec to_list(bitstring()) -> list(bit()).
to_list(BitMap) ->
    lists:reverse('_to_list'(BitMap, [])).

'_to_list'(<<>>, Acc) ->
    Acc;
'_to_list'(<<H:1, T/bitstring>>, Acc) ->
    '_to_list'(T, [H| Acc]).

%%-------------------------------------------------------------------------
%% @doc
%% Convert the provided list of ones and zeros into a bitmap.
%% @end
%%-------------------------------------------------------------------------
-spec from_list(list(bit())) -> bitstring().
from_list(List) ->
    {Size, Idxs} =
        lists:foldr(fun(0, {Cnt, Idxs}) -> {Cnt + 1, Idxs};
                       (1, {Cnt, Idxs}) -> {Cnt + 1, [Cnt + 1| Idxs]}
                    end,
                    {0, []},
                    List),
    new(lists:reverse(Idxs), Size).
