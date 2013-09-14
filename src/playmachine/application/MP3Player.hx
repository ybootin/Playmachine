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
import playmachine.event.AudioEvent;
import playmachine.event.PlaymachineEvent;
import playmachine.data.AudioData;

/**
 * A simple MP3 player that work like html5 audio tag using flash ExternalInterface
 *
 * made for the browser that does not handle html3 audio tag
 */
class MP3Player extends Sprite
{
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
     * Activate debug trace
     */
    private static var debug:Bool;

    /**
     * HaXe bootstrap
     */
    public static function main():Void
    {
        flash.Lib.current.stage.addChild(new MP3Player());
    }

    /**
     * Constructor
     */
    public function new()
    {
        super();

        //better trace ;)
        haxe.Log.trace = playmachine.helpers.LogHelper.trace;

        jsEventHandler = flash.Lib.current.loaderInfo.parameters.handler;

        debug = cast(flash.Lib.current.loaderInfo.parameters.debug);

        volume = Constants.DEFAULT_SOUND_LEVEL;

        lastPlayedTime = 0;

        initExternalCallbacks();

        // At this time we consider that player is ready to handle incoming request
        dispatchEventToExternal(PlaymachineEvent.AUDIO_READY);

        var playbackTimer = new Timer(TIMEUPDATE_DELAY);
        playbackTimer.run = checkPlayback;
    }

    /**
     * load an mp3 file
     */
    public function load(url:String):Void
    {
        // remove already setted listener
        if(audio != null) {
            audio.removeEventListener(Event.COMPLETE, onBufferFull);
            audio.removeEventListener(Event.ID3, id3Handler);
            audio.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            audio.removeEventListener(ProgressEvent.PROGRESS, onBuffer);

            pause();
        }

        // reset the last play time to start playback from begin
        lastPlayedTime = 0;

        audio = new Sound();

        audio.addEventListener(Event.COMPLETE, onBufferFull);
        audio.addEventListener(Event.ID3, id3Handler);
        audio.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        audio.addEventListener(ProgressEvent.PROGRESS, onBuffer);
        audio.load(new URLRequest(url));

        dispatchEventToExternal(AudioEvent.AUDIO_LOADSTART);
    }

    /**
     * Play to the desired location
     * @param  start start time in millisecond
     */
    public function play(?start:Null<Float> = null):Bool
    {
        if(audio != null) {
            if(channel != null) {
                channel.stop();
            }

            channel = audio.play((start != null ? start : lastPlayedTime));
            setVolume(volume);

            dispatchEventToExternal(AudioEvent.AUDIO_PLAY);

            return true;
        }

        return false;
    }

    /**
     * Pause the playback
     */
    public function pause():Void
    {
        if(channel != null) {
            channel.stop();
            channel = null;

            dispatchEventToExternal(AudioEvent.AUDIO_PAUSE);
        }
    }

    /**
     * seek to the desired percent cuePoint.
     * percent is a float between 0 and 100
     */
    public function seek(percent:Float):Void
    {
        var cuePoint:Float = audio.length * percent / 100;

        // dispatch event only if play success
        if(play(cuePoint)) {
            dispatchEventToExternal(AudioEvent.AUDIO_SEEKED);
        }

    }

    /**
     * Set the player volume
     * percent is a number between 0 and 100
     */
    public function setVolume(percent:Float):Void
    {
        if(percent == volume) {
            return;
        }

        volume = percent;

        if(channel != null) {
            var transform:SoundTransform = channel.soundTransform;
            transform.volume = percent / 100;
            channel.soundTransform = transform;

            dispatchEventToExternal(AudioEvent.AUDIO_VOLUMECHANGE);
        }
    }

    /**
     * The standard html5 audio object, shared with the playmachine
     */
    public function getAudioData():AudioData
    {
         var data = new AudioData();
        data.volume = volume;
        data.percentLoaded = (audio != null ? (audio.bytesLoaded / audio.bytesTotal * 100) : 0);
        data.duration = (audio != null ? audio.length : Math.NaN);

        if(Math.isNaN(data.percentLoaded)) {
            data.percentLoaded = 0;
        }

        data.currentTime = (channel != null ? (channel.position * data.percentLoaded / 100) : 0);
        data.percentPlayed = data.currentTime / data.duration * 100;

        return data;
    }

    /**
     * used by timer to simulate AUDIO_TIMEUPDATE and AUDIO_ENDED html5
     */
    private function checkPlayback():Void
    {
        // keep this in try catch, because it's launch through a timer
        try {
            if (channel != null && channel.position != lastPlayedTime) {
                lastPlayedTime = channel.position;
                dispatchEventToExternal(AudioEvent.AUDIO_TIMEUPDATE);

                var data:AudioData = getAudioData();
                if(data.percentLoaded == 100 && data.percentPlayed >= 99.9999) {
                    dispatchEventToExternal(AudioEvent.AUDIO_ENDED);
                }
            }
        }
        catch(e:Dynamic) {
            trace('error on checking playback');
        }
    }

    /**
     * Initiate the externals interface handler to control player with javascript
     *
     * the magic of this application ;)
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
     */
    private function dispatchEventToExternal(eventName:String):Void
    {
        if(jsEventHandler != null) {
            ExternalInterface.call(jsEventHandler,eventName,getAudioData());
        }
    }

    /**
     * Handle loaded buffer full
     */
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
        dispatchEventToExternal(AudioEvent.AUDIO_LOADEDMETADATA);
    }

    /**
     * Audio error handler
     */
    private function errorHandler(event:ErrorEvent):Void
    {
        error = event;
        dispatchEventToExternal(AudioEvent.AUDIO_ERROR);
    }

    /**
     * Handle buffer progress and dispatch progress event
     */
    private function onBuffer(event:ProgressEvent):Void
    {
        dispatchEventToExternal(AudioEvent.AUDIO_PROGRESS);
    }

    /**
     * avoid trace directly in flash, better use js console
     *
     * @param  {[type]} msg    : Dynamic       [description]
     * @param  {[type]} ?infos : haxe.PosInfos [description]
     */
    public static function trace(msg : Dynamic, ?infos : haxe.PosInfos):Void
    {
        if(debug) {
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
}