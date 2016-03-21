all:
	scalac Match.scala
	ocamlopt match.ml -o match
	scala Match
	./match
clean:
	rm -rf *.class *.cm* *.o match

