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

        updateDisplay();

        application.addEventListener(AudioEvent.AUDIO_VOLUMECHANGE,onVolumeChange,false);

        element.addEventListener('mousedown', cast(onSoundDown), false);
        element.addEventListener('click', cast(onSoundClick), false);
        element.addEventListener('mouseup', cast(onSoundUp), false);
        element.addEventListener('mousemove', cast(onSoundMove), false);

    }

    private function updateDisplay():Void
    {
        var level:HtmlElement = element.getElementByClassName('level');
        var knob:HtmlElement = element.getElementByClassName('knob');

        level.style.width = volume + "%";

        var minPos = 0;
        var maxPos = element.offsetWidth - (knob.offsetWidth / 2);

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

        updateDisplay();
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
