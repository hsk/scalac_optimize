# パターンマッチベンチマーク

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

