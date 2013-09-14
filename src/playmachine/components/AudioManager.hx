package playmachine.components;

import playmachine.core.Component;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;
import playmachine.helpers.AudioHelper;
using playmachine.helpers.AudioHelper;
import playmachine.event.ApplicationEvent;
import playmachine.event.PlaymachineEvent;
import playmachine.data.Track;
import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.core.Constants;


import js.Browser;
import js.html.Event;
import js.html.Audio;
import js.html.HtmlElement;

import haxe.Timer;

class AudioManager extends Component
{
    var audio:Audio;

    var flashPlayer:HtmlElement;

    var playerReady:Bool;

    var track:Track;

    var useFlashPlayer:Bool;

    override public function init():Void
    {
        super.init();

        application.addEventListener(PlaymachineEvent.AUDIO_READY,function(evt:Event):Void {
            initListeners();
        },false);

        audio = cast(element.getElementByClassName('audio'));

#if js
        //Browser doesn't supper MP3
        if(!audio.hasMP3()) {
            appendFlashPlayer();
        }
#end

        if(!useFlashPlayer) {
            // redispatch all audio events
            var events:Array<String> = Type.getClassFields(AudioEvent);

            for(i in 0...events.length) {
                var eventName:String = Reflect.field(AudioEvent,events[i]);

                audio.addEventListener(eventName,function(e:Event):Void {
                    application.dispatchEvent(new AudioEvent(e.type, getAudioData()));
                },false);
            }
            application.dispatchEvent(new AudioEvent(PlaymachineEvent.AUDIO_READY, getAudioData()));
        }

        //update volume, let the others components init, and handle volume change
        Timer.delay(function():Void {
            setVolume(Constants.DEFAULT_SOUND_LEVEL);
        },500);
    }

    private function setVolume(volumePercent:Float):Void
    {
        if(useFlashPlayer) {
            untyped flashPlayer.setVolume(volumePercent);
        } else {
            audio.volume = volumePercent / 100;
        }
    }

    private function seek(percent:Float):Void
    {
        if(useFlashPlayer) {
            untyped flashPlayer.seek(percent);
        } else {
            audio.currentTime = audio.duration * (percent / 100);
        }
    }

    private function play():Void
    {
        untyped useFlashPlayer ? flashPlayer.play() : audio.play();
    }

    private function pause():Void
    {
        untyped useFlashPlayer ? flashPlayer.pause() : audio.pause();
    }

    private function appendFlashPlayer():Void
    {
        if(!useFlashPlayer) {
            useFlashPlayer = true;

            //remove html5 audio tag
            element.removeChild(audio);

            var jshandlerName:String = "playmachinejshandler";
            var that = this;
            untyped {
                Browser.window.playmachinejshandler = function(eventName,eventData) {

                    if(eventName == AudioEvent.AUDIO_READY) {
                        that.flashPlayer = Browser.document.getElementById("mp3player");
                    }
                    that.application.dispatchEvent(new AudioEvent(eventName,eventData));
                };
            }
            element.setAttribute('id',  'mp3player');
            element.appendSWF('mp3player.swf?handler=' + jshandlerName,10,10);
        }
    }

    private function getAudioData():AudioData
    {
        if(useFlashPlayer) {
            return untyped cast(flashPlayer.getAudioData());
        }
        else {
            var audioData:AudioData = new AudioData();
            audioData.volume = audio.volume;
            audioData.currentTime = audio.currentTime;
            audioData.duration = audio.duration;
            audioData.percentLoaded = audio.getBufferPercent();
            audioData.percentPlayed = Math.NaN; //to be implemented

            return audioData;
        }
    }

    private function initListeners():Void
    {
        application.addEventListener(PlaymachineEvent.PLAY_TRACK_REQUEST,cast(onPlayRequest),false);
        application.addEventListener(PlaymachineEvent.REMOVE_TRACK_REQUEST,cast(onRemoveRequest),false);
        application.addEventListener(PlaymachineEvent.SEEK_REQUEST,cast(onSeekRequest),false);
        application.addEventListener(PlaymachineEvent.VOLUME_REQUEST,cast(onVolumeRequest),false);

        application.addEventListener(PlaymachineEvent.PLAY_REQUEST,function(e:Event):Void {
            play();
        },false);
        application.addEventListener(PlaymachineEvent.PAUSE_REQUEST,function(e:Event):Void {
            pause();
        },false);

        application.addEventListener(AudioEvent.AUDIO_ENDED,cast(onTrackEnded),false);

    }

    private function onVolumeRequest(evt:PlaymachineEvent):Void
    {
        setVolume(cast(evt.data));
    }

    private function onSeekRequest(e:PlaymachineEvent):Void
    {
        seek(cast(e.data));
    }

    private function onRemoveRequest(e:PlaymachineEvent):Void
    {
        var t:Track = cast(e.data);
        if(t.id == track.id) {
            untyped useFlashPlayer ? flashPlayer.load("") : audio.setAttribute('src','');
            track = null;
            pause();
        }
    }

    private function onPlayRequest(e:PlaymachineEvent):Void
    {
        track = cast(e.data);
        untyped useFlashPlayer ? flashPlayer.load(track.file) : audio.setAttribute('src',track.file);
        play();
    }

    private function onTrackEnded(evt:Event):Void
    {
        application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.NEXT_TRACK_REQUEST));
    }
}