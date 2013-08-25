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

    override public function init():Void
    {
        super.init();

        audio = rootElement.getElementByClassName('audio');

        groupElement.addEventListener(Events.PLAY_TRACK_REQUEST,cast(onPlayRequest),false);
    }

    private function onPlayRequest(e:CustomEvent):Void
    {
        var t:Track = cast(e.detail);
        audio.setAttribute('src',t.file);
        untyped audio.play();
    }
}