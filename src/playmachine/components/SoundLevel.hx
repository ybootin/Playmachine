package playmachine.components;

import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;
import playmachine.core.Component;
import playmachine.event.PlaymachineEvent;
import playmachine.core.Constants;

import js.html.HtmlElement;
import js.html.Event;
import js.html.MouseEvent;

class SoundLevel extends Component
{
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

        updateDisplay(volume);

        application.addEventListener(AudioEvent.AUDIO_PLAY,onPlay,false);
        application.addEventListener(AudioEvent.AUDIO_VOLUMECHANGE,onVolumeChange,false);

        element.addEventListener('mousedown', cast(onSoundDown), true);
        element.addEventListener('click', cast(onSoundClick), true);
        element.addEventListener('mouseup', cast(onSoundUp), true);
        element.addEventListener('mousemove', cast(onSoundMove), true);
    }

    private function updateDisplay(volume:Float):Void
    {
        var knob:HtmlElement = element.getElementByClassName('knob');
        var level:HtmlElement = element.getElementByClassName('level');

        var minPos = 0;
        var maxPos = element.offsetWidth - knob.offsetWidth;

        var newPos:Float = (element.offsetWidth * volume / 100) - knob.offsetWidth;

        if(level.hasClass('horizontal')) {
            newPos = (element.offsetHeight * volume / 100) - knob.offsetHeight;
        }

        if(newPos < minPos) {
            newPos = minPos;

            sendVolumeRequest(0);
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

    private function onPlay(evt:AudioEvent):Void
    {
        volume = evt.data.volume;
        updateDisplay(evt.data.volume);
    }

    private function onVolumeChange(evt:AudioEvent):Void
    {
        if(evt.data.volume <= 0) {
            volumeBeforeMute = volume;
        }

        volume = evt.data.volume;

        updateDisplay(volume);
    }


    /**
     * Called when mouse is moving on the sound level
     * @param  {Event} evt: event fired
     * @return {Void}
     */
    private function onSoundMove(evt:MouseEvent):Void
    {
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
    }

    /**
     * Called when we release the click on the sound level
     * @param  {Event} evt: event fired
     * @return {Void}
     */
    private function onSoundUp(evt:MouseEvent):Void
    {
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
        var percentClick:PercentClick = target.getPercentClick(evt);

        if(target.getAttribute('class') == "level") {
            var f:Float = percentClick.width;
            if(target.hasClass('horizontal')) {
                f = percentClick.height;
            }
            var percent:Float = f * 100;
            sendVolumeRequest(percent);
        }
    }
}
