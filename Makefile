PLAYMACHINE=bin/playMachine.*
SOURCES=Makefile src/*/*.hx src/*/*/*.hx resources/* templates/*.html

make: playmachine
playmachine: $(PLAYMACHINE)

$(PLAYMACHINE): $(SOURCES) build.hxml
	haxe build.hxml
	#rm -Rf bin/images
	#cp -Rf templates/images/ bin/images/
