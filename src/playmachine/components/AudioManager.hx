package playmachine.components;

import playmachine.core.Component;
using playmachine.helpers.HtmlElementHelper;
import playmachine.helpers.HtmlElementHelper;
import playmachine.event.ApplicationEvent;
import playmachine.event.PlaymachineEvent;
import playmachine.data.Track;
import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.core.Constants;
import playmachine.core.CrossAudio;

import js.Browser;
import js.html.Event;

import haxe.Timer;

class AudioManager extends Component
{
    var audio:CrossAudio;

    var currentTrack:Track;

    override public function init():Void
    {
        super.init();

        audio = new CrossAudio(this);

        audio.addEventListener(PlaymachineEvent.AUDIO_READY,onReady,false);

        // redispatch all audio events
        var events:Array<String> = Type.getClassFields(AudioEvent);

        for(i in 0...events.length) {
            var eventName:String = Reflect.field(AudioEvent,events[i]);

            audio.addEventListener(eventName,function(e:AudioEvent):Void {
                application.dispatchEvent(e);
            },false);
        }

        audio.init();
    }

    private function initListeners():Void
    {
        application.addEventListener(PlaymachineEvent.PLAY_TRACK_REQUEST,cast(onPlayRequest),false);
        application.addEventListener(PlaymachineEvent.REMOVE_TRACK_REQUEST,cast(onRemoveRequest),false);
        application.addEventListener(PlaymachineEvent.SEEK_REQUEST,cast(onSeekRequest),false);
        application.addEventListener(PlaymachineEvent.VOLUME_REQUEST,cast(onVolumeRequest),false);

        application.addEventListener(PlaymachineEvent.PLAY_REQUEST,cast(function(e:PlaymachineEvent):Void {
            audio.play();
        }),false);
        application.addEventListener(PlaymachineEvent.PAUSE_REQUEST,cast(function(e:PlaymachineEvent):Void {
            audio.pause();
        }),false);

        application.addEventListener(AudioEvent.AUDIO_ENDED,cast(onTrackEnded),false);
    }

    private function onReady(evt:PlaymachineEvent):Void
    {
        trace('ready');
        initListeners();
        audio.setVolume(Constants.DEFAULT_SOUND_LEVEL);
    }

    private function onVolumeRequest(evt:PlaymachineEvent):Void
    {
        audio.setVolume(cast(evt.data));
    }

    private function onSeekRequest(e:PlaymachineEvent):Void
    {
        audio.seek(cast(e.data));
    }

    private function onRemoveRequest(e:PlaymachineEvent):Void
    {
        var t:Track = cast(e.data);
        if(t.id == currentTrack.id) {
            audio.unload();
            currentTrack = null;
            audio.pause();
        }
    }

    private function onPlayRequest(e:PlaymachineEvent):Void
    {
        currentTrack = cast(e.data);
        audio.load(currentTrack.file);
        audio.play();
    }

    private function onTrackEnded(evt:Event):Void
    {
        application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.NEXT_TRACK_REQUEST));
    }
}