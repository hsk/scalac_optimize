# パターンマッチベンチマーク

BNF

```
e ::= i | x | e + e | e - e | let rec x = e in e | λ x -> e | if e <= e then e else e | e e
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
C ⊢ λ x -> e ⇓ λ x -> e

C ⊢ e1 ⇓ λ x -> e0   C ⊢ e2 ⇓ v2
C,x ⇓ v2 ⊢ e0 ⇓ v
----------------------------------------- (E-App)
C ⊢ e1 e2 ⇓ v

C,x ⇓ v1 ⊢ e1 ⇓ v1   C,x ⇓ v1 ⊢ e2 ⇓ v2
----------------------------------------- (E-LetRec)
C ⊢ let rec x = e1 in e2 ⇓ v2
```

※注意 fibさえ動けばよいのでクロージャ無しで、ダイナミックスコープです。

実行結果

```
$ make
scalac Match.scala
ocamlopt match.ml -o match
swipl -nodebug -g true -O -q --toplevel=main --stand_alone=true -o plmatch -c match.pl
scala Match
562ms
519ms
493ms
483ms
493ms
avg 510ms
./match
478 ms
478 ms
477 ms
477 ms
477 ms
avg 477 ms
./plmatch
40040 ms
40017 ms
40018 ms
40007 ms
40090 ms
```

考察

Prologで書いた実装はfib(30)はスタックオーバーフローになります。カットを使えばfib(30)に対応出来るかもしれません。
Scalaはscalacの最適化オプションを使っていません。最初は遅いのですがHotSpotが効いて速くなるのでしょう。
OCamlはocamloptを使うと最適化出来てネイティブにコンパイルされHotSpotはないので最初から速いのでしょう。

Scalaはsbtを使えば、起動時の重さは軽減出来ます。初期実行時の遅さは仕方ないでしょう。
起動の重さと初期実行時の重さが気になるような場合はLLVM化するのがよいのでしょう。
コンパイル自体を避けるには動的に実行するのが良さそうです。
JVMに期待する事は、Androidのようにコンパイル結果の保存をする事で起動時と初期実行時の速度低下を抑える仕組みです。

様々なデータ構造を作り出してベンチマークを取ってみれば、マイクロベンチマークでは分からない問題点が出てくるかもしれません。