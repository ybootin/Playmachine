package playmachine.ui;

import playmachine.event.HTML5AudioEvents;
import playmachine.data.AudioData;
import application.model.Component;
import playmachine.event.Events;
import js.Lib;
import js.Dom;
import application.helpers.HtmlDomHelper;
using application.helpers.HtmlDomHelper;

/**
 * The seekBar UI component
 */
class SeekBar extends Component
{
    /**
     * Holds the last audioData object received from audio event
     */
    private var audioData:AudioData;

    private var played:HtmlDom;
    private var buffered:HtmlDom;

    private var isDragging:Bool;

    override public function init():Void
    {
        audioData = new AudioData();

        played = element.getElementByClassName('played');
        buffered = element.getElementByClassName('buffered');

        reset();

        played.addEventListener('click',cast(onClick),false);
        buffered.addEventListener('click',cast(onClick),false);

        played.addEventListener('mouseup',cast(onMouseUp),false);
        buffered.addEventListener('mouseup',cast(onMouseUp),false);
        played.addEventListener('mousedown',cast(onMouseDown),false);
        buffered.addEventListener('mousedown',cast(onMouseDown),false);
        played.addEventListener('mousemove',cast(onMouseMove),false);
        buffered.addEventListener('mousemove',cast(onMouseMove),false);

        global.addEventListener(HTML5AudioEvents.AUDIO_TIMEUPDATE,cast(onProgress),false);
        global.addEventListener(HTML5AudioEvents.AUDIO_PROGRESS,cast(onBuffer),false);

        global.addEventListener(Events.NEXT_TRACK_REQUEST,onTrackChange,false);
        global.addEventListener(Events.PREVIOUS_TRACK_REQUEST,onTrackChange,false);
        global.addEventListener(Events.PLAY_TRACK_REQUEST,onTrackChange,false);
    }

    private function reset():Void
    {
        setProgressPosition(0);
        setBufferPositon(0);
    }

    private function setProgressPosition(percent:Float):Void 
    {
        played.style.width = percent + "%";
    }

    private function setBufferPositon(percent:Float):Void 
    {
        buffered.style.width = percent + "%";
    }

    private function onProgress(evt:CustomEvent):Void
    {
        audioData = cast(evt.detail);

        setProgressPosition(audioData.percentPlayed);
    }

    private function onBuffer(evt:CustomEvent):Void
    {
        audioData = cast(evt.detail);

        setBufferPositon(audioData.percentLoaded);
    }

    private function onClick(evt:MouseEvent):Void
    {
        var target:HtmlDom = cast(evt.target);

        var isBufferBar:Bool = (target.className.indexOf('buffered') != -1);

        // use percent adapt for click on the playbar while loading not fully completed
        var percentAdapt = (isBufferBar ? 1 : (audioData.currentTime / audioData.duration * (1 /(audioData.percentLoaded / 100))));
        var seekPercent:Float = target.getPercentClick(evt) * 100 * percentAdapt;

        dispatchEventOnGroup(Events.SEEK_REQUEST,seekPercent);
    }

    private function onMouseDown(evt:MouseEvent):Void 
    {
        isDragging = true;
        onClick(evt);
    }

    private function onMouseUp(evt:MouseEvent):Void 
    {
        isDragging = false;
    }

    private function onMouseMove(evt:MouseEvent):Void 
    {
        if (isDragging) {
            onClick(evt);
        }
    }

    private function onTrackChange(evt:Event):Void
    {
        reset();
    }
}