package playmachine.ui;

import playmachine.event.HTML5AudioEvents;
import playmachine.data.AudioData;
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
import playmachine.core.Constants;

class ControlBar extends BaseComponent
{
    private var playPauseButton:HtmlDom;
    private var previousButton:HtmlDom;
    private var forwardButton:HtmlDom;
    private var muteButton:HtmlDom;
    private var soundLevel:HtmlDom;

    private var playing:Bool;

    private var volume:Float;
    private var volumeBeforeMute:Float;

    private var soundDragging:Bool;

    override public function init():Void
    {
        volume = Constants.DEFAULT_SOUND_LEVEL;

        playPauseButton = rootElement.getElementByClassName('playPauseButton');
        previousButton = rootElement.getElementByClassName('previousButton');
        forwardButton = rootElement.getElementByClassName('forwardButton');
        muteButton = rootElement.getElementByClassName('muteButton');
        soundLevel = rootElement.getElementByClassName('soundLevel');

        updateSoundLevel();

        groupElement.addEventListener(HTML5AudioEvents.AUDIO_PLAY,onPlay,false);
        groupElement.addEventListener(HTML5AudioEvents.AUDIO_PAUSE,onPause,false);
        groupElement.addEventListener(HTML5AudioEvents.AUDIO_VOLUMECHANGE,cast(onVolumeChange),false);

        forwardButton.addEventListener('click',function(e:Event):Void {
            dispatchEventOnGroup(Events.NEXT_TRACK_REQUEST);
        },false);

        previousButton.addEventListener('click',function(e:Event):Void {
            dispatchEventOnGroup(Events.PREVIOUS_TRACK_REQUEST);
        },false);

        muteButton.addEventListener('click',function(e:Event):Void {
            sendVolumeRequest((volume <= 0) ? volumeBeforeMute : 0);
        },false);

        playPauseButton.addEventListener('click',function(e:Event):Void {
            dispatchEventOnGroup(playing ? Events.PAUSE_REQUEST : Events.PLAY_REQUEST);
        },false);

        soundLevel.addEventListener('mousedown', cast(onSoundDown), false);
        soundLevel.addEventListener('click', cast(onSoundClick), false);
        soundLevel.addEventListener('mouseup', cast(onSoundUp), false);
        soundLevel.addEventListener('mousemove', cast(onSoundMove), false);

    }

    private function updateSoundLevel():Void
    {
        (volume == 0) ? muteButton.addClass('muted') : muteButton.removeClass('muted');

        var level:HtmlDom = soundLevel.getElementByClassName('level');
        var knob:HtmlDom = soundLevel.getElementByClassName('knob');

        level.style.width = volume + "%";

        var minPos = 0;
        var maxPos = soundLevel.offsetWidth - (knob.offsetWidth / 2);

        var newPos:Float = level.offsetWidth - (knob.offsetWidth / 2);
        if(newPos < minPos) {
            newPos = minPos;
        }
        if(newPos >= maxPos) {
            newPos = maxPos;
        }
        knob.style.left = Std.string(newPos) + "px";
    }

    private function sendVolumeRequest(volumePercent:Float):Void
    {
        dispatchEventOnGroup(Events.VOLUME_REQUEST, volumePercent);
    }


    private function onVolumeChange(evt:CustomEvent):Void
    {
        var audio:AudioData = cast(evt.detail);

        if(audio.volume <= 0) {
            volumeBeforeMute = volume;
        }

        volume = audio.volume;

        updateSoundLevel();
    }

    private function onPlay(e:Event):Void
    {
        playing = true;
        playPauseButton.addClass('playing');
    }

    private function onPause(e:Event):Void
    {
        playing = false;
        playPauseButton.removeClass('playing');
    }

    /**
     * Called when mouse is moving on the sound level
     * @param  {Event} evt: event fired
     * @return {Void}
     */
    private function onSoundMove(evt:MouseEvent):Void {
        if (soundDragging) 
        {
            onSoundClick(evt);
        }
    }

    /**
     * Called when we clicked on the sound level
     * @param  {Event} evt: event fired
     * @return {Void}
     */
    private function onSoundDown(evt:MouseEvent):Void 
    {
        soundDragging = true;
        onSoundClick(evt);
    }

    /**
     * Called when we release the click on the sound level
     * @param  {Event} evt: event fired
     * @return {Void}
     */
    private function onSoundUp(evt:MouseEvent):Void {
        soundDragging = false;
    }

    /**
     * Prevent default actions when event click is fired
     * @param  {[type]} evt:Event [description]
     * @return {[type]}           [description]
     */
    private function onSoundClick(evt:MouseEvent):Void 
    {
        var target:HtmlDom = cast(evt.target);

        sendVolumeRequest((target.getPercentClick(evt) * 100));
    }
}