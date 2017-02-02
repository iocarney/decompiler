%% Author: PCHAPIER
%% Created: 25 mai 2010
-module(utility).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([decompile/1, decompdir/1]).

-export([shuffle/1]).


%%
%% API Functions
%%

decompdir(Dir) ->
    Cmd = "cd " ++ Dir,
    os:cmd(Cmd),
    L = os:cmd("dir /B *.beam"),
    L1 = re:split(L,"[\t\r\n+]",[{return,list}]),
    io:format("decompdir: ~p~n",[L1]),
    decompile(L1).


decompile(Beam = [H|_]) when is_integer(H) ->
    io:format("decompile: ~p~n",[Beam]),
    {ok,{_,[{abstract_code,{_,AC}}]}} = beam_lib:chunks(Beam ++ ".beam",[abstract_code]),
    {ok,File} = file:open(Beam ++ ".erl",[write]),
    io:fwrite(File,"~s~n", [erl_prettypr:format(erl_syntax:form_list(AC))]),
    file:close(File);

decompile([H|T]) ->
    io:format("decompile: ~p~n",[[H|T]]),
    decompile(removebeam(H)),
    decompile(T);

decompile([]) ->
    ok.

shuffle(P) ->
    Max = length(P)*10000,
    {_,R}= lists:unzip(lists:keysort(1,[{random:uniform(Max),X} || X <- P])),
    R.



%%
%% Local Functions
%%
removebeam(L) ->
    removebeam1(lists:reverse(L)).

removebeam1([$m,$a,$e,$b,$.|T]) ->
    lists:reverse(T);
removebeam1(L) ->
    lists:reverse(L).
