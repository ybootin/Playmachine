# overridable vars
JS=bin/playMachine.js
SWF=bin/playMachine.swf
MP3PLAYER=bin/mp3player.swf
ASSETSDIR=bin/assets
TEMPLATE=default
TEMPLATENAME=template.html
TEMPLATEDIR=templates/$(TEMPLATE)
HAXEPARAMS=
SWFPARAMS=-swf-version 10.2 $(HAXEPARAMS)
MAIN=playmachine.application.PlayMachine
RESOURCE=$(TEMPLATEDIR)/$(TEMPLATENAME)@template
SOURCES=Makefile src/*/*/*.hx $(TEMPLATEDIR)/*.html

make: assets js mp3player swf
debug: 
	make HAXEPARAMS=-debug 
swf: $(SWF)
js: $(JS)
assets: $(ASSETSDIR)
playmachine: $(PLAYMACHINE)
mp3player: $(MP3PLAYER)
clean:
	rm -Rf $(ASSETSDIR)
	rm -f $(JS)
	rm -f $(SWF)

$(SWF): $(SOURCES)
	haxe -swf $(SWF) -main $(MAIN) -cp src -resource $(RESOURCE) -lib cocktail --remap js:cocktail -swf-version 10.2 $(HAXEPARAMS)

$(JS): $(SOURCES)
	haxe -js $(JS) -main $(MAIN) -cp src -resource $(RESOURCE) $(HAXEPARAMS)

$(ASSETSDIR): $(TEMPLATEDIR)/* $(TEMPLATEDIR)/assets/*
	rm -Rf $(ASSETSDIR)
	cp -Rf $(TEMPLATEDIR)/assets/ $(ASSETSDIR)

$(MP3PLAYER): $(SOURCES)
	haxe -main playmachine.application.MP3Player -swf $(MP3PLAYER) -cp src $(SWFPARAMS)

