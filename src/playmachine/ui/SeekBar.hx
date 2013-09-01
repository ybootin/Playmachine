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

import playmachine.helpers.AudioHelper;
using playmachine.helpers.AudioHelper;

class SeekBar extends BaseComponent
{
    private var currentTime:Float;
    private var totalTime:Float;

    var played:HtmlDom;
    var buffered:HtmlDom;

    override public function init():Void
    {
        groupElement.addEventListener(HTML5AudioEvents.AUDIO_TIMEUPDATE,cast(onProgress),false);
        groupElement.addEventListener(HTML5AudioEvents.AUDIO_PROGRESS,cast(onBuffer),false);

        rootElement.addEventListener('click',onClick,false);

        played = rootElement.getElementByClassName('played');
        buffered = rootElement.getElementByClassName('buffered');

        reset();
    }

    private function reset():Void
    {
        played.style.width = "0%";
        buffered.style.width = "0%";
    }

    private function onProgress(evt:CustomEvent):Void
    {
        var audioElement:Audio = cast(evt.detail);

        currentTime = cast(audioElement.currentTime);
        totalTime = cast(audioElement.duration);

        var progressPercent:Float = (currentTime / totalTime) * 100;

        if (progressPercent >= 0 && played != null) {
            played.style.width = progressPercent + "%";
        }
    }

    private function onBuffer(evt:CustomEvent):Void
    {
        var audioElement:Audio = cast(evt.detail);
        var bufferPercent = audioElement.getBufferPercent();

        if(bufferPercent > 0) {
            buffered.style.width = bufferPercent + "%";
        }
    }

    private function onClick(evt:Event):Void
    {

    }
}