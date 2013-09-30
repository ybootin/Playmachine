# override default template (default), "make TEMPLATE=templatefolder"
if [ "$(TEMPLATE)" == "" ] ; then
	TEMPLATE=toonzshop

# override default template name (template.html)
if [ "$(NAME)" == "" ] ; then
	NAME=template.html

# run "make debug" build an application that display haxe trace in console
ifeq (debug,$(firstword $(MAKECMDGOALS)))
	HAXEPARAMS=-debug
endif

JS=bin/playMachine.js
SWF=bin/playMachine.swf
MP3PLAYER=bin/mp3player.swf
ASSETSDIR=bin/assets
TEMPLATESDIR=templates/$(TEMPLATE)
SWFPARAMS=-swf-version 10.2 $(HAXEPARAMS)
MAIN=-main playmachine.application.PlayMachine
RESOURCE=-resource $(TEMPLATESDIR)/$(NAME)@template
SOURCES=Makefile src/*/*/*.hx $(TEMPLATESDIR)/*.html

make: assets js mp3player swf
debug: make
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
	haxe -swf $(SWF) $(MAIN) -cp src $(RESOURCE) -lib cocktail --remap js:cocktail -swf-version 10.2 $(HAXEPARAMS)

$(JS): $(SOURCES)
	haxe -js $(JS) $(MAIN) -cp src $(RESOURCE) $(HAXEPARAMS)

$(ASSETSDIR): $(TEMPLATESDIR)/*
	rm -Rf $(ASSETSDIR)
	cp -Rf templates/$(TEMPLATE)/assets/ $(ASSETSDIR)

$(MP3PLAYER): $(SOURCES)
	haxe -main playmachine.application.MP3Player -swf $(MP3PLAYER) -cp src $(SWFPARAMS)

