# By default, default template is used, but you can override it by "make TEMPLATE=templatefolder"
if [ "$(TEMPLATE)" == "" ] ; then
	TEMPLATE=toonzshop

# run "make debug" build an application that display haxe trace in console
ifeq (debug,$(firstword $(MAKECMDGOALS)))
	HAXEPARAMS=-debug
endif

JS=bin/playMachine.js
SWF=bin/playMachine.swf
MP3PLAYER=bin/mp3player.swf
ASSETS=bin/assets
MP3PLAYERPARAMS=-main playmachine.application.MP3Player -swf bin/mp3player.swf -cp src -swf-version 10.2 $(HAXEPARAMS)
JSPARAMS=-js bin/playMachine.js -main playmachine.application.PlayMachine -cp src -resource templates/$(TEMPLATE)/player.html@template $(HAXEPARAMS)
SWFPARAMS=-swf bin/playMachine.swf -main playmachine.application.PlayMachine -cp src -resource templates/$(TEMPLATE)/player.html@template -lib cocktail --remap js:cocktail -swf-version 10.2 $(HAXEPARAMS)
TEMPLATESDIR=templates/$(TEMPLATE)/*
SOURCES=Makefile src/*/*/*.hx templates/$(TEMPLATE)/*.html

make: assets js mp3player swf
debug: make
swf: $(SWF)
js: $(JS)
assets: $(ASSETS)
playmachine: $(PLAYMACHINE)
mp3player: $(MP3PLAYER)
clean:
	rm -Rf bin/assets
	rm -f $(JS)
	rm -f $(SWF)

$(SWF): $(SOURCES)
	haxe $(SWFPARAMS)

$(JS): $(SOURCES)
	haxe $(JSPARAMS)

$(ASSETS): $(TEMPLATESDIR)
	rm -Rf bin/assets
	cp -Rf templates/toonzshop/assets/ bin/assets/

$(MP3PLAYER): $(SOURCES)
	haxe $(MP3PLAYERPARAMS)

