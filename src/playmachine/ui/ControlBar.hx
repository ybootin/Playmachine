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

class ControlBar extends BaseComponent
{
    private var playPauseButton:HtmlDom;
    private var previousButton:HtmlDom;
    private var forwardButton:HtmlDom;
    private var muteButton:HtmlDom;
    private var soundLevel:HtmlDom;
    private var soundKnob:HtmlDom;

    private var playing:Bool;

    private var volume:Float;
    private var muted:Bool;
    private var volumeBeforeMute:Float;

    private var soundDragging:Bool;

    override public function init():Void
    {
        playPauseButton = rootElement.getElementByClassName('playPauseButton');
        previousButton = rootElement.getElementByClassName('previousButton');
        forwardButton = rootElement.getElementByClassName('forwardButton');
        muteButton = rootElement.getElementByClassName('muteButton');
        soundLevel = rootElement.getElementByClassName('level');
        soundKnob = rootElement.getElementByClassName('knob');


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
            if(!muted) {
                volumeBeforeMute = volume;
                sendVolumeRequest(0);
            }
            else
            {
                trace(volumeBeforeMute);
                sendVolumeRequest(volumeBeforeMute);
            }
        },false);

        playPauseButton.addEventListener('click',function(e:Event):Void {
            if(playing) {
                dispatchEventOnGroup(Events.PAUSE_REQUEST);
            }
            else {
                dispatchEventOnGroup(Events.PLAY_REQUEST);
            }
        },false);

        soundLevel.addEventListener('mousedown', onSoundDown, false);
        soundLevel.addEventListener('click', onSoundClick, false);
        Lib.document.addEventListener('mouseup', cast(onSoundUp), false);
        Lib.document.addEventListener('mousemove', cast(onSoundMove), false);

    }

    private function onVolumeChange(evt:CustomEvent):Void
    {
        var audio:Audio = cast(evt.detail);
        volume = audio.volume * 100;
        trace('volume change ' + volume);
        muted = (volume == 0);

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


    private function sendVolumeRequest(volumePercent:Float):Void
    {
        dispatchEventOnGroup(Events.VOLUME_REQUEST, volumePercent);
    }

    /**
     * Called when mouse is moving on the sound level
     * @param  {Event} evt: event fired
     * @return {Void}
     */
    private function onSoundMove(evt:MouseEvent):Void {

        evt.preventDefault();
        if (soundDragging) {
            var target:HtmlDom = cast(evt.target);

            sendVolumeRequest(target.getPercentClick(evt));
        }
    }

    /**
     * Called when we clicked on the sound level
     * @param  {Event} evt: event fired
     * @return {Void}
     */
    private function onSoundDown(evt:Event):Void {
        evt.preventDefault();
        soundDragging = true;
    }

    /**
     * Prevent default actions when event click is fired
     * @param  {[type]} evt:Event [description]
     * @return {[type]}           [description]
     */
    private function onSoundClick(evt:Event):Void {
        evt.preventDefault();
    }

    /**
     * Called when we release the click on the sound level
     * @param  {Event} evt: event fired
     * @return {Void}
     */
    private function onSoundUp(evt:MouseEvent):Void {
        evt.preventDefault();
        if (soundDragging) {
            soundDragging = false;
            var target:HtmlDom = cast(evt.target);

            sendVolumeRequest(target.getPercentClick(evt));
        }
    }

    private function onVolumeRequest(evt:CustomEvent):Void {
        volume = cast(evt.detail);


    }

    private function updateSoundLevel():Void
    {
        muted ? muteButton.addClass('muted') : muteButton.removeClass('muted');

        soundLevel.style.width = volume + "%";
    }

}