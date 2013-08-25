package playmachine.ui;

import playmachine.event.HTML5AudioEvents;
import application.helpers.HtmlDomHelper;
using application.helpers.HtmlDomHelper;
import playmachine.data.Track;
import application.core.BaseComponent;
import playmachine.event.Events;
import js.Lib;
import js.Dom;
import haxe.Json;
import haxe.Template;
import haxe.Resource;
import application.core.Logger;

class PlaylistPanel extends BaseComponent
{
    private var template:String;

    override public function init():Void
    {
        super.init();
        //setup the current template base noe content
        template = rootElement.innerHTML;
        rootElement.innerHTML = "";

        rootElement.addEventListener(Events.ADD_TRACK_REQUEST,cast(addTrackRequestHandler),false);
        // debug
        // load the tracks resources, and add tracks

        var data:Array<Dynamic> = Json.parse(Resource.getString('tracks'));

        for(i in 0...data.length) {
            dispatchEventOnGroup(Events.ADD_TRACK_REQUEST,data[i]);
        }
    }

    private function addTrackRequestHandler(e:CustomEvent):Void
    {
        var t:Track = cast(e.detail);
        addTrack(t);
    }

    private function addTrack(t:Track):Void
    {
        var tpl:Template = new Template(template);
        rootElement.innerHTML += tpl.execute({title:t.title});

        var trackLine:HtmlDom = Lib.document.getElementById('track' + t.id);

        var onTrackClick = function(e:Event):Void {
            dispatchEventOnGroup(Events.PLAY_TRACK_REQUEST,t);
        }

        trackLine.addEventListener('click',onTrackClick,false);
    }
}