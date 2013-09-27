PLAYMACHINE=bin/playMachine.js bin/playMachine.swf
MP3PLAYER=bin/mp3player.swf
MP3PLAYERPARAMS=-main playmachine.application.MP3Player -swf bin/mp3player.swf -debug -cp src -swf-version 10.2
SOURCES=Makefile src/*/*/*.hx templates/toonzshop/*.html

make: playmachine mp3player
playmachine: $(PLAYMACHINE)
mp3player: $(MP3PLAYER)

$(PLAYMACHINE): $(SOURCES) build.hxml
	haxe build.hxml
	rm -Rf bin/assets
	cp -Rf templates/toonzshop/assets/ bin/assets/

$(MP3PLAYER): $(SOURCES)
	haxe $(MP3PLAYERPARAMS)
