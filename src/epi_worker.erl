%%%-------------------------------------------------------------------
%%% @author Juan Puig <juan.puig@gmail.com>
%%% @copyright (C) 2012, Juan Puig
%%% @doc
%%% Individual worker. It's given a number of tests to be performed.
%%% @end
%%% Created : 15 Nov 2012 by Juan Puig <juan.puig@gmail.com>
%%%-------------------------------------------------------------------
-module(epi_worker).

-export([calculus/1,
         calculus/2,
         calculus/3]).

%% exported functions

calculus(N) ->
    ok = gen_state(),
    calculate(N, 0, []).

calculus(N, Master) ->
    calculus(N, Master, []).

calculus(N, Master, Opt) ->
    ok = gen_state(),
    Val = calculate(N, 0, Opt),
    Master ! {ok, {self(), Val}}.

%% internal functions

calculate(0, Targets, _Opt) ->
    Targets;
calculate(Rem, Targets, Opt) ->
    %% case lists:member(verbose, Opt) of
    %%     true ->
    %%         Total = proplists:get_value(total, Opt, 1),
    %%         Percentage = 100 - (100*Rem / Total),
    %%         io:format("% ~p~n", [Percentage]);
    %%     _ ->
    %%         ok
    %% end,
    {X, Y} = {gen_point(), gen_point()},
    case is_target(X, Y) of
        true ->
            calculate(Rem-1, Targets+1, Opt);
        _ ->
            calculate(Rem-1, Targets, Opt)
    end.

is_target(X,Y) ->
    square(X) + square(Y) =< 1.    

gen_state() ->
    Now = now(),
    random:seed(Now),
    ok.

gen_point() ->
    random:uniform().

square(X) ->
    X*X.
    
