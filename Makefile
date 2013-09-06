PLAYMACHINE=bin/playMachine.*
MP3PLAYER=bin/mp3player.swf
SOURCES=Makefile src/*/*.hx src/*/*/*.hx resources/* templates/*.html

make: playmachine mp3player
playmachine: $(PLAYMACHINE)
mp3player: $(MP3PLAYER)

$(PLAYMACHINE): $(SOURCES) build.hxml
	haxe build.hxml
	rm -Rf bin/images
	cp -Rf templates/images/ bin/images/

$(MP3PLAYER): $(SOURCES) build-mp3player.hxml
	haxe build-mp3player.hxml
