all:
	scalac Match.scala
	ocamlopt match.ml -o match
	swipl -nodebug -g true -O -q --toplevel=main --stand_alone=true -o plmatch -c match.pl
	scala Match
	./match
	./plmatch
clean:
	rm -rf *.class *.cm* *.o match

