JS=bin/playMachine.js
SWF=bin/playMachine.swf
MP3PLAYER=bin/mp3player.swf
ASSETS=bin/assets
MP3PLAYERPARAMS=-main playmachine.application.MP3Player -swf bin/mp3player.swf -debug -cp src -swf-version 10.2
JSPARAMS=-js bin/playMachine.js -main playmachine.application.PlayMachine -cp src -resource templates/toonzshop/player.html@template -debug
SWFPARAMS=-swf bin/playMachine.swf -main playmachine.application.PlayMachine -cp src -resource templates/toonzshop/player.html@template -lib cocktail --remap js:cocktail -swf-version 10.2 -debug
TEMPLATESDIR=templates/*
SOURCES=Makefile src/*/*/*.hx templates/toonzshop/*.html

make: assets js mp3player swf
swf: $(SWF)
js: $(JS)
assets: $(ASSETS)
playmachine: $(PLAYMACHINE)
mp3player: $(MP3PLAYER)

$(SWF): $(SOURCES)
	haxe $(SWFPARAMS)

$(JS): $(SOURCES)
	haxe $(JSPARAMS)

$(ASSETS): $(TEMPLATESDIR)
	rm -Rf bin/assets
	cp -Rf templates/toonzshop/assets/ bin/assets/

$(MP3PLAYER): $(SOURCES)
	haxe $(MP3PLAYERPARAMS)
