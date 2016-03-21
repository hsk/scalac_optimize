# パターンマッチベンチマーク

BNF

```
e ::= i | x | e + e | e * e | let rec x = e in e | λ x -> e | if e <= e then e else e | e e
v ::= i | λ x -> e | e
```

評価規則

```
----------------------------------------- (E-Int)
C ⊢ i ⇓ i

C ⊢ e1 ⇓ v1   C ⊢ e2 ⇓ v2   v1 <= v2
C ⊢ e3 ⇓ v
----------------------------------------- (E-IfTrue)
C ⊢ if e1 <= e2 then e3 else e4 ⇓ v

C ⊢ e1 ⇓ v1   C ⊢ e2 ⇓ v2   v1 > v2
C ⊢ e4 ⇓ v
----------------------------------------- (E-IfFalse)
C ⊢ if e1 <= e2 then e3 else e4 ⇓ v

C ⊢ e1 ⇓ v1   C ⊢ e2 ⇓ v2   v is v1 + v2
----------------------------------------- (E-Plus)
C ⊢ e1 + e2 ⇓ v

C ⊢ e1 ⇓ v1   C ⊢ e2 ⇓ v2   v is v1 - v2
----------------------------------------- (E-Minus)
C ⊢ e1 - e2 ⇓ v

lookup(C, x ⇓ v)
----------------------------------------- (E-Var)
C ⊢ x ⇓ v

----------------------------------------- (E-Fun)
C ⊢ λ x -> e ⇓ C ⊢ λ x -> e

C ⊢ e1 ⇓ C2 ⊢ λ x -> e0   C ⊢ e2 ⇓ v2
C2,x ⇓ v2 ⊢ e0 ⇓ v
----------------------------------------- (E-App)
C ⊢ e1 e2 ⇓ v

C,x ⇓ v1 ⊢ e1 ⇓ v1   C,x ⇓ v1 ⊢ e2 ⇓ v2
----------------------------------------- (E-LetRec)
C ⊢ let rec x = e1 in e2 ⇓ v2
```

実行結果

```
scalac Match.scala
ocamlopt match.ml -o match
scala Match
558ms
520ms
483ms
481ms
495ms
avg 508ms
./match
480 ms
483 ms
480 ms
480 ms
477 ms
avg 480 ms
```

最初はScalaは遅いけどHotSpotが効いて速くなるのだと思う。OCamlは最初から速い。

