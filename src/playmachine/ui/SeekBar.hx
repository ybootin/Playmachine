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
    private var bufferPercent:Float;

    var played:HtmlDom;
    var buffered:HtmlDom;

    override public function init():Void
    {
        groupElement.addEventListener(HTML5AudioEvents.AUDIO_TIMEUPDATE,cast(onProgress),false);
        groupElement.addEventListener(HTML5AudioEvents.AUDIO_PROGRESS,cast(onBuffer),false);

        played = rootElement.getElementByClassName('played');
        buffered = rootElement.getElementByClassName('buffered');

        played.addEventListener('click',cast(onClick),false);
        buffered.addEventListener('click',cast(onClick),false);

        reset();
    }

    private function reset():Void
    {
        played.style.width = "0%";
        buffered.style.width = "0%";
    }

    private function onProgress(evt:CustomEvent):Void
    {
        var audioElement:HTML5AudioData = cast(evt.detail);

        currentTime = audioElement.currentTime;
        totalTime = audioElement.duration;

        if (audioElement.percentPlayed >= 0 && played != null) {
            played.style.width = audioElement.percentPlayed + "%";
        }
    }

    private function onBuffer(evt:CustomEvent):Void
    {
        var audioElement:HTML5AudioData = cast(evt.detail);

        if(audioElement.percentLoaded > 0) {
            buffered.style.width = audioElement.percentLoaded + "%";
        }
    }

    private function onClick(evt:MouseEvent):Void
    {
        var target:HtmlDom = cast(evt.target);

        var offset:Array<Int> = target.getOffset();
        var realX:Float = evt.clientX - offset[0];
        var percentClick:Float = realX / target.offsetWidth;
        var isBufferBar:Bool = (target.className.indexOf('buffered') != -1);
        var seekPercent:Float;

        if(isBufferBar) {
            seekPercent = percentClick * bufferPercent;
        }
        else {
            seekPercent = (percentClick * 100) * (currentTime / totalTime);
        }

        dispatchEventOnGroup(Events.SEEK_REQUEST,seekPercent);
    }
}