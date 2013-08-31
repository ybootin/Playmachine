package playmachine.audio;

import application.core.BaseComponent;
import application.helpers.HtmlDomHelper;
using application.helpers.HtmlDomHelper;

import playmachine.event.Events;
import playmachine.data.Track;

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

    }

    private function onRemoveRequest(e:CustomEvent):Void
    {
        var t:Track = cast(e.detail);
        if(t.id == track.id) {
            untyped audio.pause();
        }
    }

    private function onPlayRequest(e:CustomEvent):Void
    {
        track = cast(e.detail);
        audio.setAttribute('src',track.file);
        untyped audio.play();
    }
}