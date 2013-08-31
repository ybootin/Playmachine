package playmachine.ui;

import slplayer.ui.DisplayObject;
import slplayer.ui.group.IGroupable;
using slplayer.ui.group.IGroupable.Groupable;

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

        groupElement.addEventListener(Events.ADD_TRACK_REQUEST,cast(addTrackRequestHandler),false);

        if(data.tracks != null) {
            for(i in 0...data.tracks.length) {
                dispatchEventOnGroup(Events.ADD_TRACK_REQUEST,data.tracks[i]);
            }
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
        var e:HtmlDom = Lib.document.createElement('div');
        e.innerHTML = tpl.execute({title:t.title,id:t.id});

        e.addEventListener('click',function(e:Event):Void {
            dispatchEventOnGroup(Events.PLAY_TRACK_REQUEST,t);
        },false);

        rootElement.appendChild(e);
    }
}