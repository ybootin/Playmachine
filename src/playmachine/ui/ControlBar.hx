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
    var playPauseButton:HtmlDom;
    var previousButton:HtmlDom;
    var forwardButton:HtmlDom;

    private var playing:Bool;

    override public function init():Void
    {
        playPauseButton = rootElement.getElementByClassName('playPauseButton');
        previousButton = rootElement.getElementByClassName('previousButton');
        forwardButton = rootElement.getElementByClassName('forwardButton');

        groupElement.addEventListener(HTML5AudioEvents.AUDIO_PLAY,onPlay,false);
        groupElement.addEventListener(HTML5AudioEvents.AUDIO_PAUSE,onPause,false);

        forwardButton.addEventListener('click',function(e:Event):Void {
            dispatchEventOnGroup(Events.NEXT_TRACK_REQUEST);
        },false);

        previousButton.addEventListener('click',function(e:Event):Void {
            dispatchEventOnGroup(Events.PREVIOUS_TRACK_REQUEST);
        },false);

        playPauseButton.addEventListener('click',function(e:Event):Void {
            if(playing) {
                dispatchEventOnGroup(Events.PAUSE_REQUEST);
            }
            else {
                dispatchEventOnGroup(Events.PLAY_REQUEST);
            }
        },false);
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
}