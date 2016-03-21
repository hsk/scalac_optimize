:- initialization(main).
:- op(1200, xfx, [ -- ]).
:- op(910, xfx, [ ⊢ ]).
:- op(900, xfx, [ ⇓ ]).
:- op(700, xfx, <=).
:- op(900, xfx, [ in ]).
:- op(500, yfx, $).
:- op(10, fx, λ).
term_expansion(A -- B, B :- A).

lookup([X ⇓ V| _], X ⇓ V).
lookup([X1 ⇓ _| Γ], X ⇓ V):- X1\==X, lookup(Γ, X ⇓ V).

%% evaluation rules

integer(I)
--%------------------------------------ (E-Int)
_ ⊢ I ⇓ I.

C ⊢ E1 ⇓ V1, C ⊢ E2 ⇓ V2, V1 =< V2,
C ⊢ E3 ⇓ V
--%------------------------------------ (E-IfTrue)
C ⊢ if(E1 <= E2, E3, _) ⇓ V.

C ⊢ E1 ⇓ V1, C ⊢ E2 ⇓ V2, V1 > V2,
C ⊢ E4 ⇓ V
--%------------------------------------ (E-IfFalse)
C ⊢ if(E1 <= E2, _, E4) ⇓ V.

C ⊢ E1 ⇓ V1, C ⊢ E2 ⇓ V2, V is V1 + V2
--%------------------------------------ (E-Plus)
C ⊢ E1 + E2 ⇓ V.

C ⊢ E1 ⇓ V1, C ⊢ E2 ⇓ V2, V is V1 - V2
--%------------------------------------ (E-Minus)
C ⊢ E1 - E2 ⇓ V.

atom(X), lookup(C, X ⇓ V)
--%------------------------------------ (E-Var)
C ⊢ X ⇓ V.

!
--%------------------------------------ (E-Fun)
C ⊢ (λ X -> E) ⇓ (C ⊢ λ X -> E).

C ⊢ E1 ⇓ (C2 ⊢ λ X -> E0), C ⊢ E2 ⇓ V2,
[(X ⇓ V2)|C2] ⊢ E0 ⇓ V
--%------------------------------------ (E-App)
C ⊢ (E1 $ E2) ⇓ V.

[X ⇓ V1|C] ⊢ E1 ⇓ V1,
[X ⇓ V1|C] ⊢ E2 ⇓ V2
--%------------------------------------ (E-LetRec)
C ⊢ letrec(X = E1 in E2) ⇓ V2.

run(E) :-
  write(E),
  [] ⊢ E ⇓ V, write(' ⇓ '), write(V),
  nl.

main :-
  run(if(1<=2,2,3)),
  run(if(2<=1,2,3)),
  run(1 + 2),
  run(1 - 2),
  run(λ x -> x),
  run((λ x -> x) $ 1),
  run((λ x -> λ y -> x+y) $ 1 $ 2),
  run(letrec(sum=(λ x -> if(x <= 0, x, x+(sum $ (x - 1)))) in (sum $ 10))),
  run(letrec(fib=(λ x -> if(x <= 1, x, (fib $ (x - 2))+(fib $ (x - 1)))) in (fib $ 20))),
  halt.
