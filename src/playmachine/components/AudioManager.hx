package playmachine.audio;

import application.model.Component;
import application.helpers.HtmlDomHelper;
using application.helpers.HtmlDomHelper;
import playmachine.helpers.AudioHelper;
using playmachine.helpers.AudioHelper;
import playmachine.event.Events;
import playmachine.data.Track;
import playmachine.event.HTML5AudioEvents;
import playmachine.data.AudioData;
import playmachine.core.Constants;

import js.Dom;
import js.Lib;

import haxe.Timer;

class AudioManager extends Component
{
    var audio:Audio;

    var flashPlayer:HtmlDom;

    var playerReady:Bool;

    var track:Track;

    var useFlashPlayer:Bool;

    override public function init():Void
    {
        super.init();

        global.addEventListener(HTML5AudioEvents.AUDIO_READY,function(evt:Event):Void {
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
            var events:Array<String> = Type.getClassFields(HTML5AudioEvents);

            for(i in 0...events.length) {
                var eventName:String = Reflect.field(HTML5AudioEvents,events[i]);

                audio.addEventListener(eventName,function(e:Event):Void {
                    dispatchEventOnGroup(e.type, getAudioData());
                },false);
            }

            dispatchEventOnGroup(HTML5AudioEvents.AUDIO_READY, getAudioData());
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
                Lib.window.playmachinejshandler = function(eventName,eventData) {

                    if(eventName == HTML5AudioEvents.AUDIO_READY) {
                        that.flashPlayer = Lib.document.getElementById("mp3player");
                    }

                    that.dispatchEventOnGroup(eventName,eventData);
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
        global.addEventListener(Events.PLAY_TRACK_REQUEST,cast(onPlayRequest),false);
        global.addEventListener(Events.REMOVE_TRACK_REQUEST,cast(onRemoveRequest),false);
        global.addEventListener(Events.SEEK_REQUEST,cast(onSeekRequest),false);
        global.addEventListener(Events.VOLUME_REQUEST,cast(onVolumeRequest),false);

        global.addEventListener(Events.PLAY_REQUEST,function(e:Event):Void {
            play();
        },false);
        global.addEventListener(Events.PAUSE_REQUEST,function(e:Event):Void {
            pause();
        },false);

        global.addEventListener(HTML5AudioEvents.AUDIO_ENDED,cast(onTrackEnded),false);

    }

    private function onVolumeRequest(evt:CustomEvent):Void
    {
        setVolume(cast(evt.detail));
    }

    private function onSeekRequest(e:CustomEvent):Void
    {
        seek(cast(e.detail));
    }

    private function onRemoveRequest(e:CustomEvent):Void
    {
        var t:Track = cast(e.detail);
        if(t.id == track.id) {
            untyped useFlashPlayer ? flashPlayer.load("") : audio.setAttribute('src','');
            track = null;
            pause();
        }
    }

    private function onPlayRequest(e:CustomEvent):Void
    {
        track = cast(e.detail);
        untyped useFlashPlayer ? flashPlayer.load(track.file) : audio.setAttribute('src',track.file);
        play();
    }

    private function onTrackEnded(evt:Event):Void
    {
        dispatchEventOnGroup(Events.NEXT_TRACK_REQUEST);
    }
}