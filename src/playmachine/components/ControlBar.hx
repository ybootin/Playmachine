package playmachine.components;

import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;
import playmachine.core.Component;
import playmachine.event.PlaymachineEvent;


import js.html.HtmlElement;
import js.html.Event;
import js.html.MouseEvent;

class ControlBar extends Component
{
    private var playPauseButton:HtmlElement;
    private var previousButton:HtmlElement;
    private var forwardButton:HtmlElement;

    private var playing:Bool;

    override public function init():Void
    {
        // Check if element exists !
        if(element == null) {
            return;
        }

        playPauseButton = getChildElement('playPauseButton');
        previousButton = getChildElement('previousButton');
        forwardButton = getChildElement('forwardButton');

        application.addEventListener(AudioEvent.AUDIO_PLAY,onPlay,false);
        application.addEventListener(AudioEvent.AUDIO_PAUSE,onPause,false);

        forwardButton.addEventListener('click',function(e:Event):Void {
            application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.NEXT_TRACK_REQUEST));
        },false);

        previousButton.addEventListener('click',function(e:Event):Void {
            application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.PREVIOUS_TRACK_REQUEST));
        },false);


        playPauseButton.addEventListener('click',function(e:Event):Void {
            application.dispatchEvent(new PlaymachineEvent(playing ? PlaymachineEvent.PAUSE_REQUEST : PlaymachineEvent.PLAY_REQUEST));
        },false);
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

}
