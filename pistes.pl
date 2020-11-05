atomtoint([],[]).
atomtoint([Head|Tail],[New|List]):-
    atom_number(Head,New),
    atomtoint(Tail,List).

read_input(File, N, List) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N),
    New is N + 1,
    once(read_lines(Stream, New, List,0)).

read_lines(Stream, N, List, SeqNum) :-
    ( N == 0 -> List = []
    ; N > 0  -> read_line(Stream, Element, SeqNum),
                Nm1 is N-1,
		NewSeq is SeqNum + 1,
                read_lines(Stream, Nm1, RestElement, NewSeq),
                List = [Element | RestElement]).

read_line(Stream, (SeqNum,NumKeysReq,NumKeysRew,Stars,KeysReq,KeysRew), SeqNum) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(List, ' ', Atom),
    atomtoint(List, [NumKeysReq,NumKeysRew,Stars|T]),
    split_list(NumKeysReq,T,KeysReq,KeysRew).

split_list(_, [], [], []).
split_list(0, L, [], L).
split_list(K, [Head|Tail], L1, L2) :-
	NewK is K-1,
	split_list(NewK, Tail, Retlist, L2),
	!,
	append([Head],Retlist, L1).

max([X],X) :-
	!, 
	true.
max([X|Xs], M):- 
	max(Xs, M), 
	M >= X.
max([X|Xs], X):- 
	max(Xs, M),
	X >  M.

valid_entry([], _):-!.
valid_entry([Head|Tail], Earned) :-
	member(Head, Earned),	
	!,
	delete_element(Head, Earned, Newearned),
	valid_entry(Tail, Newearned).

delete_element(_, [], []).
delete_element(Element, [Head|Tail], Retlist) :-
	( Element =:= Head ->
		Retlist = Tail
	; delete_element(Element, Tail, Templist),
	  append([Head], Templist, Retlist)
	).
	    
delete_all(Targetlist, [], Targetlist).
delete_all(Targetlist, [Head|Tail], Retlist) :-
	delete_element(Head, Targetlist, Templist),
	delete_all(Templist, Tail, Retlist).

move(State, NextState, Level) :-
	legal_move(State, NextState, Level).

legal_move((StarsGained, KeysGained, Rem_levels), (NewStarsGained, NewKeysGained, NewRem_levels), (SeqNum, NumKeysReq, _NumKeysRew, Stars, KeysReq, KeysRew)) :-
	NewStarsGained is StarsGained + Stars,
	length(KeysGained,N),
	N >= NumKeysReq,
	delete_element(SeqNum, Rem_levels, NewRem_levels),
	valid_entry(KeysReq, KeysGained),
	delete_all(KeysGained, KeysReq, Partial_keys),
	append(Partial_keys, KeysRew, NewKeysGained).
	
all_moves(State, NextState, Levels) :-
	State = (_StarsGained, _KeysGained, Rem_levels),
	Level = (SeqNum, _NumKeysReq, _NumKeysRew, _Stars, _KeysReq, _KeysRew),
	member(Level, Levels),
	member(SeqNum, Rem_levels),
	move(State, NextState, Level).

solution(State, FinalState, Levels) :- 
	( \+ all_moves(State, _, Levels) ->
		FinalState = State
	; all_moves(State, NextState, Levels),
	  solution(NextState, FinalState, Levels)
	).
	
init_state(N, [Head|_] , (Stars, KeysRew, Rem_levels)) :-
	Head = (_SeqNum, _NumKeysReq, _NumKeysRew, Stars, _KeysReq, KeysRew),
	numlist(1, N, Rem_levels).

pistes(File, FinalStars) :-
	read_input(File, N, Levels),
	init_state(N, Levels, InitState), 
	findall(Stars,solution(InitState,(Stars,_,_),Levels),StarList),
	sort(StarList, SortedStarList),
	max(SortedStarList, FinalStars).
