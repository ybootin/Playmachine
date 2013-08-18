package playmachine.ui;

import playmachine.event.HTML5AudioEvent;
import playmachine.helpers.HtmlDomHelper;
using playmachine.helpers.HtmlDomHelper;
import playmachine.data.Track;
import js.Lib;
import js.Dom;
import haxe.Json;

class PlaylistPanel extends BaseComponent
{
    private var termplate:String;

    public function init():Void
    {
        template = rootElement.innerHTML;
        rootElement.innerHTML = "";

        rootElement.addEventListener(Events.ADD_TRACK_REQUEST,cast(addTrackRequestHandler),false);
        // debug
        // load the tracks resources, and add tracks
        var data:Array<Track> = cast(Json.parse(Resources.getString('tracks')));

        for(i in data) {
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

        var trackLine:HtmlDom = document.getElementById('track' + t.id);

        var onTrackClick = function(e:Event):Void {
            dispatchEventOnGroup(Events.PLAY_TRACK_REQUEST,t);
        }

        trackLine.addEventListener('click',onTrackClick,false);
    }
}