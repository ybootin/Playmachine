package playmachine.core;

import playmachine.event.ApplicationEvent;
import playmachine.event.PlaymachineEvent;
import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.core.Constants;
import playmachine.event.Event;
import playmachine.event.EventDispatcher;
import playmachine.event.IEventDispatcher;
import playmachine.core.IComponent;

#if js
using playmachine.helpers.HtmlElementHelper;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.AudioHelper;
import playmachine.helpers.AudioHelper;
import js.html.Audio;
import js.html.HtmlElement;
import js.Browser;
#else
import playmachine.application.MP3Player;
#end

/**
 * Cross audio class
 *
 * Handle audio component for all supported platform
 */
class CrossAudio extends EventDispatcher
{
    private var useMP3Player:Bool;

    private var component:IComponent;
#if js
    private var audio:Audio;
    private var mp3player:Dynamic;
//Avoid compilation problems for others target (audio not fully supported by cocktail)
#else
    private var audio:Dynamic;
    private var mp3player:MP3Player;
#end

    public function new(component:IComponent)
    {
        super();

        this.component = component;

        useMP3Player = true;
    }

    public function load(file:String):Void
    {
        untyped useMP3Player ? mp3player.load(file) : audio.setAttribute('src',file);
    }

    public function unload():Void
    {
        untyped useMP3Player ? mp3player.load("") : audio.setAttribute('src','');
    }

    public function setVolume(volumePercent:Float):Void
    {
        try {
            if(useMP3Player) {
                untyped mp3player.setVolume(volumePercent);
            } else {
                audio.volume = volumePercent / 100;
            }
        }
        catch(e:Dynamic) {
            //
        }
    }

    public function seek(percent:Float):Void
    {
        if(useMP3Player) {
            untyped mp3player.seek(percent);
        } else {
            audio.currentTime = audio.duration * (percent / 100);
        }
    }

    public function play():Void
    {
        untyped useMP3Player ? mp3player.play() : audio.play();
    }

    public function pause():Void
    {
        untyped useMP3Player ? mp3player.pause() : audio.pause();
    }

    public function getAudioData():AudioData
    {
        if(useMP3Player) {
            return untyped cast(mp3player.getAudioData());
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

    public function init():Void
    {
#if js
        if(useMP3Player) {
            var jshandlerName:String = "playmachinejshandler";
            var playmachinejshandler = function(eventName,eventData):Void {
                if(eventName == PlaymachineEvent.AUDIO_READY) {
                    mp3player = cast(Browser.document.getElementById("mp3player"));

                    //now audio is ready
                    dispatchEvent(new PlaymachineEvent(PlaymachineEvent.AUDIO_READY));
                }
                else {
                    dispatchEvent(new AudioEvent(eventName,eventData));
                }
            };

            // IMPORTANT, attach the callback function to the window object
            Reflect.setField(Browser.window,jshandlerName,playmachinejshandler);

            var mp3player:HtmlElement = cast(Browser.document.createElement('div'));
            mp3player.setAttribute('id',  'mp3player');

            component.element.appendChild(mp3player);

            mp3player.appendSWF('mp3player.swf?handler=' + jshandlerName,10,10);
        }

        else {
            audio = cast(Browser.document.createElement('audio'));
        }
#else
        mp3player = new MP3Player();
#end

//flash version always use mp3player
#if js
        if(!useMP3Player) {
#end
            //init events
            var events:Array<String> = Type.getClassFields(AudioEvent);

            for(i in 0...events.length) {
                var eventName:String = Reflect.field(AudioEvent,events[i]);
#if js
                audio.addEventListener(eventName,function(e:Event):Void {
#else
                mp3player.addEventListener(eventName,function(e:AudioEvent):Void {
#end
                    dispatchEvent(new AudioEvent(e.type, getAudioData()));
                },false);

            }

            //now audio is ready
            dispatchEvent(new PlaymachineEvent(PlaymachineEvent.AUDIO_READY));
#if js
        }
#end
    }
}