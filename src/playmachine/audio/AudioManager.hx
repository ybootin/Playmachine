package playmachine.audio;

import application.core.BaseComponent;
import application.helpers.HtmlDomHelper;
using application.helpers.HtmlDomHelper;

import playmachine.event.Events;
import playmachine.data.Track;
import playmachine.event.HTML5AudioEvents;

import js.Dom;
import js.Lib;

class AudioManager extends BaseComponent
{
    var audio:HtmlDom;

    var track:Track;

    override public function init():Void
    {
        super.init();

        audio = rootElement.getElementByClassName('audio');

        groupElement.addEventListener(Events.PLAY_TRACK_REQUEST,cast(onPlayRequest),false);
        groupElement.addEventListener(Events.REMOVE_TRACK_REQUEST,cast(onRemoveRequest),false);
        groupElement.addEventListener(Events.PLAY_REQUEST,function(e:Event):Void {
            play();
        },false);
        groupElement.addEventListener(Events.PAUSE_REQUEST,function(e:Event):Void {
            pause();
        },false);

        // redispatch all audio events
        var events:Array<String> = Type.getClassFields(HTML5AudioEvents);

        for(i in 0...events.length) {
            var eventName:String = Reflect.field(HTML5AudioEvents,events[i]);

            audio.addEventListener(eventName,function(e:Event):Void {
                dispatchEventOnGroup(e.type, audio);
            },false);
        }
    }

    private function onRemoveRequest(e:CustomEvent):Void
    {
        var t:Track = cast(e.detail);
        if(t.id == track.id) {
            audio.setAttribute('src','');
            track = null;
            pause();
        }
    }

    private function onPlayRequest(e:CustomEvent):Void
    {
        track = cast(e.detail);
        audio.setAttribute('src',track.file);
        play();
    }

    private function play():Void
    {
        untyped audio.play();
    }

    private function pause():Void
    {
        untyped audio.pause();
    }
}