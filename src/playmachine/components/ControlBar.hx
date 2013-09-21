package playmachine.components;

import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;
import playmachine.data.Track;
import playmachine.core.Component;
import playmachine.event.PlaymachineEvent;
import haxe.Json;
import haxe.Template;
import haxe.Resource;
import playmachine.core.Constants;

import js.html.HtmlElement;
import js.html.Event;
import js.html.MouseEvent;

class ControlBar extends Component
{
    private var playPauseButton:HtmlElement;
    private var previousButton:HtmlElement;
    private var forwardButton:HtmlElement;
    private var muteButton:HtmlElement;
    private var soundLevel:HtmlElement;

    private var playing:Bool;

    private var volume:Float;
    private var volumeBeforeMute:Float;

    private var soundDragging:Bool;

    override public function init():Void
    {
        // Check if element exists !
        if(element == null) {
            return;
        }

        volume = Constants.DEFAULT_SOUND_LEVEL;

        playPauseButton = getChildElement('playPauseButton');
        previousButton = getChildElement('previousButton');
        forwardButton = getChildElement('forwardButton');
        muteButton = getChildElement('muteButton');
        soundLevel = getChildElement('soundLevel');

        updateSoundLevel();

        application.addEventListener(AudioEvent.AUDIO_PLAY,onPlay,false);
        application.addEventListener(AudioEvent.AUDIO_PAUSE,onPause,false);
        application.addEventListener(AudioEvent.AUDIO_VOLUMECHANGE,onVolumeChange,false);

        forwardButton.addEventListener('click',function(e:Event):Void {
            application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.NEXT_TRACK_REQUEST));
        },false);

        previousButton.addEventListener('click',function(e:Event):Void {
            application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.PREVIOUS_TRACK_REQUEST));
        },false);

        muteButton.addEventListener('click',function(e:Event):Void {
            sendVolumeRequest((volume <= 0) ? volumeBeforeMute : 0);
        },false);

        playPauseButton.addEventListener('click',function(e:Event):Void {
            application.dispatchEvent(new PlaymachineEvent(playing ? PlaymachineEvent.PAUSE_REQUEST : PlaymachineEvent.PLAY_REQUEST));
        },false);

        soundLevel.addEventListener('mousedown', cast(onSoundDown), false);
        soundLevel.addEventListener('click', cast(onSoundClick), false);
        soundLevel.addEventListener('mouseup', cast(onSoundUp), false);
        soundLevel.addEventListener('mousemove', cast(onSoundMove), false);

    }

    private function updateSoundLevel():Void
    {
        (volume == 0) ? muteButton.addClass('muted') : muteButton.removeClass('muted');

        var level:HtmlElement = soundLevel.getElementByClassName('level');
        var knob:HtmlElement = soundLevel.getElementByClassName('knob');

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
        application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.VOLUME_REQUEST, volumePercent));
    }


    private function onVolumeChange(evt:AudioEvent):Void
    {
        if(evt.data.volume <= 0) {
            volumeBeforeMute = volume;
        }

        volume = evt.data.volume;

        updateSoundLevel();
    }

    private function onPlay(e:AudioEvent):Void
    {
        playing = true;
        playPauseButton.addClass('playing');
    }

    private function onPause(e:AudioEvent):Void
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
        var target:HtmlElement = cast(evt.target);

        sendVolumeRequest((target.getPercentClick(evt) * 100));
    }
}