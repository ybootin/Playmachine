package playmachine.application;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.external.ExternalInterface;
import haxe.Timer;

import playmachine.core.Constants;
import playmachine.event.HTML5AudioEvents;

/**
 * A simple MP3 player that work like html5 audio tag using flash ExternalInterface
 *
 * made for the browser that does not handle html3 audio tag
 */
class MP3Player extends Sprite
{
    /**
     * Dispatch when player is ready to play !
     */
    public static inline var PLAYER_READY_EVENT:String = "playerReady";

    /**
     * Holds the default delay for sending timeupdate event
     */
    public static inline var TIMEUPDATE_DELAY:Int = 200;

    /**
     * Holds the global js function that will handle event
     */
    private var jsEventHandler:String;

    /**
     * Holds the current Sound Object
     */
    private var audio:Sound;

    /**
     * Holds the current soundChannel Object
     */
    private var channel:SoundChannel;

    /**
     * the current volume percent
     * volume is a number between 0 and 100
     */
    private var volume:Float;

    /**
     * Holds the la error event that occur
     */
    private var error:ErrorEvent;

    /**
     * Holds the timer for the playback
     */
    private var playbackTimer:Timer;

    /**
     * Holds the last headTime the the playback event was sent
     */
    private var lastPlayedTime:Float;

    /**
     * Indicate if the external inetrface callback are exposed or not
     */
    private var isExposed:Bool;

    /**
     * HaXe bootstrap method
     */
    public static function main():Void
    {
        flash.Lib.current.stage.addChild(new MP3Player());
    }

    public function new()
    {
        super();

        //better trace ;)
        haxe.Log.trace = playmachine.application.MP3Player.trace;

        jsEventHandler = flash.Lib.current.loaderInfo.parameters.handler;

        volume = Constants.DEFAULT_SOUND_LEVEL;

        lastPlayedTime = 0;

        initExternalCallbacks();

        dispatchEventToExternal(PLAYER_READY_EVENT);

        var playbackTimer = new Timer(TIMEUPDATE_DELAY);
        playbackTimer.run = checkPlayback;
    }

    /**
     * load an mp3 file
     */
    public function load(url:String):Void
    {
        // remove allready setted listener
        if(audio != null) {
            audio.removeEventListener(Event.COMPLETE, onBufferFull);
            audio.removeEventListener(Event.ID3, id3Handler);
            audio.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            audio.removeEventListener(ProgressEvent.PROGRESS, onBuffer);

            pause();
        }

        audio = new Sound();

        audio.addEventListener(Event.COMPLETE, onBufferFull);
        audio.addEventListener(Event.ID3, id3Handler);
        audio.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        audio.addEventListener(ProgressEvent.PROGRESS, onBuffer);
        audio.load(new URLRequest(url));

        dispatchEventToExternal(HTML5AudioEvents.AUDIO_LOADSTART);
    }

    /**
     * Play to the desired location
     * @param  start start time in millisecond
     */
    public function play(?start:Float = 0):Void
    {
        if(channel != null) {
            channel.stop();
        }
        channel = audio.play((start > 0 ? start : null));
        setVolume(volume);

        dispatchEventToExternal(HTML5AudioEvents.AUDIO_PLAY);
    }

    public function pause():Void
    {
        channel.stop();

        dispatchEventToExternal(HTML5AudioEvents.AUDIO_PAUSE);
    }

    /**
     * seek to the desired percent cuePoint.
     * percent is a float between 0 and 100
     */
    public function seek(percent:Float):Void
    {
        var cuePoint:Float = audio.length * percent / 100;
        play(cuePoint);

        dispatchEventToExternal(HTML5AudioEvents.AUDIO_SEEKED);
    }

    /**
     * Set the player volume
     * percent is a number between 0 and 100
     */
    public function setVolume(percent:Float):Void
    {
        volume = percent;

        var transform:SoundTransform = channel.soundTransform;
        transform.volume = percent / 100;
        channel.soundTransform = transform;

        dispatchEventToExternal(HTML5AudioEvents.AUDIO_VOLUMECHANGE);
    }

    /**
     * The standard html5 audio object, shared with the playmachine
     */
    public function getAudioData():HTML5AudioData
    {
         var data = new HTML5AudioData();
        data.volume = volume;
        data.percentLoaded = (audio != null ? (audio.bytesLoaded / audio.bytesTotal * 100) : 0);
        data.duration = (audio != null ? audio.length : Math.NaN);

        if(Math.isNaN(data.percentLoaded)) {
            data.percentLoaded = 0;
        }

        data.currentTime = (channel != null ? (channel.position * data.percentLoaded / 100) : 0);
        data.percentPlayed = lastPlayedTime / data.duration * 100;

        return data;
    }

    /**
     * used by timer to simulate AUDIO_TIMEUPDATE and AUDIO_ENDED html5
     */
    private function checkPlayback():Void
    {
        try {
            if (channel != null && channel.position != lastPlayedTime) {
                lastPlayedTime = channel.position;
                dispatchEventToExternal(HTML5AudioEvents.AUDIO_TIMEUPDATE);

                var data:HTML5AudioData = getAudioData();
                if(data.percentLoaded == 100 && audio.length == channel.position) {
                    dispatchEventToExternal(HTML5AudioEvents.AUDIO_ENDED);
                }
            }
        }
        catch(e:Dynamic) {
            trace('error on checking playback');
        }
    }

    /**
     * Initiate the externals interface handler
     * @return [description]
     */
    private function initExternalCallbacks():Void
    {
        if(!isExposed) {
            isExposed = true;

            ExternalInterface.addCallback("load",load);
            ExternalInterface.addCallback("play",play);
            ExternalInterface.addCallback("pause",pause);
            ExternalInterface.addCallback("seek",seek);
            ExternalInterface.addCallback("setVolume",setVolume);
            ExternalInterface.addCallback("getAudioData",getAudioData);
        }
    }

    /**
     * Dispatch HTML5 event to the javascript handler method
     * @param  eventName [description]
     * @return           [description]
     */
    private function dispatchEventToExternal(eventName:String):Void
    {
        if(jsEventHandler != null) {
            ExternalInterface.call(jsEventHandler,eventName,getAudioData());
        }
    }

    private function onBufferFull(event:Event):Void
    {
        //no html5 event for this
    }

    /**
     * Send the loadedmetadata event
     * When id3 tag have been received, duration is know
     */
    private function id3Handler(event:Event):Void
    {
        dispatchEventToExternal(HTML5AudioEvents.AUDIO_LOADEDMETADATA);
    }

    private function errorHandler(event:ErrorEvent):Void
    {
        error = event;
        dispatchEventToExternal(HTML5AudioEvents.AUDIO_ERROR);
    }

    /**
     * Handle buffer progress and dispatch progress event
     */
    private function onBuffer(event:ProgressEvent):Void
    {
        dispatchEventToExternal(HTML5AudioEvents.AUDIO_PROGRESS);
    }

    /**
     * avoid trace directly in flash, better use js console
     *
     * @param  {[type]} msg    : Dynamic       [description]
     * @param  {[type]} ?infos : haxe.PosInfos [description]
     */
    public static function trace(msg : Dynamic, ?infos : haxe.PosInfos):Void
    {
        if (infos != null) {
            msg = infos.fileName + ':' + infos.lineNumber + ': ' + msg + ' (' + infos.className + '.' + infos.methodName + ')';
        }

        if (ExternalInterface.available) {
            ExternalInterface.call('console.log', '[mp3player] ' + msg);
        }
        else {
            trace('[mp3player] ' + msg);
        }

    }
}