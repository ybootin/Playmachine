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
        application.addEventListener(PlaymachineEvent.PLAY_TRACK_REQUEST,onPlayRequest,false);
        application.addEventListener(PlaymachineEvent.REMOVE_TRACK_REQUEST,onRemoveRequest,false);
        application.addEventListener(PlaymachineEvent.SEEK_REQUEST,onSeekRequest,false);
        application.addEventListener(PlaymachineEvent.VOLUME_REQUEST,onVolumeRequest,false);

        application.addEventListener(PlaymachineEvent.PLAY_REQUEST,function(e:PlaymachineEvent):Void {
            audio.play();
        },false);
        application.addEventListener(PlaymachineEvent.PAUSE_REQUEST,function(e:PlaymachineEvent):Void {
            audio.pause();
        },false);

        audio.addEventListener(AudioEvent.AUDIO_ENDED,onTrackEnded,false);
    }

    private function onTrackEnded(evt:AudioEvent):Void
    {
        application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.NEXT_TRACK_REQUEST));
    }

    private function onReady(evt:PlaymachineEvent):Void
    {
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
            audio.pause();
            audio.unload();
            currentTrack = null;
        }
    }

    private function onPlayRequest(e:PlaymachineEvent):Void
    {
        currentTrack = cast(e.data);
        audio.load(currentTrack.file);
        audio.play();
    }
}