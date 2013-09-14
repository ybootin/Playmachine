package playmachine.components;

import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.core.Component;
import playmachine.event.PlaymachineEvent;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;

import js.html.HtmlElement;
import js.html.Event;
import js.html.MouseEvent;
import js.Browser;

/**
 * The seekBar UI component
 */
class SeekBar extends Component
{
    /**
     * Holds the last audioData object received from audio event
     */
    private var audioData:AudioData;

    private var played:HtmlElement;
    private var buffered:HtmlElement;

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

        application.addEventListener(AudioEvent.AUDIO_TIMEUPDATE,cast(onProgress),false);
        application.addEventListener(AudioEvent.AUDIO_PROGRESS,cast(onBuffer),false);

        application.addEventListener(PlaymachineEvent.NEXT_TRACK_REQUEST,onTrackChange,false);
        application.addEventListener(PlaymachineEvent.PREVIOUS_TRACK_REQUEST,onTrackChange,false);
        application.addEventListener(PlaymachineEvent.PLAY_TRACK_REQUEST,onTrackChange,false);
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

    private function onProgress(evt:AudioEvent):Void
    {
        setProgressPosition(evt.data.percentPlayed);
    }

    private function onBuffer(evt:AudioEvent):Void
    {
        setBufferPositon(evt.data.percentLoaded);
    }

    private function onClick(evt:MouseEvent):Void
    {
        var target:HtmlElement = cast(evt.target);

        var isBufferBar:Bool = (target.className.indexOf('buffered') != -1);

        // use percent adapt for click on the playbar while loading not fully completed
        var percentAdapt = (isBufferBar ? 1 : (audioData.currentTime / audioData.duration * (1 /(audioData.percentLoaded / 100))));
        var seekPercent:Float = target.getPercentClick(evt) * 100 * percentAdapt;

        application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.SEEK_REQUEST,seekPercent));
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