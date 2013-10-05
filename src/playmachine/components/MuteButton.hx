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

class MuteButton extends Component
{
    private var volume:Float;
    private var volumeBeforeMute:Float;

    override public function init():Void
    {
        // Check if element exists !
        if(element == null) {
            return;
        }

        volume = Constants.DEFAULT_SOUND_LEVEL;
        updateButtonStatus();

        application.addEventListener(AudioEvent.AUDIO_VOLUMECHANGE,onVolumeChange,false);

        element.addEventListener('click',function(e:Event):Void {
            sendVolumeRequest((volume <= 0) ? volumeBeforeMute : 0);
        },false);
    }

    private function sendVolumeRequest(volumePercent:Float):Void
    {
        application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.VOLUME_REQUEST, volumePercent));
    }

    private function updateButtonStatus():Void
    {
       (volume <= 10) ? element.addClass('muted') : element.removeClass('muted');
    }


    private function onVolumeChange(evt:AudioEvent):Void
    {
        if(evt.data.volume <= 0 && volume > 0) {
            volumeBeforeMute = volume;
        }

        volume = evt.data.volume;

        updateButtonStatus();
    }

}
