package playmachine.event;

#if js
import playmachine.event.Event;
#else
import flash.events.Event;
#end

import playmachine.data.AudioData;

/**
 * HTML5 <audio> tag events
 *
 * see http://www.w3.org/wiki/HTML/Elements/audio
 */
class AudioEvent extends Event
{
    public static var AUDIO_LOADSTART:String = "loadstart";    //The user agent begins looking for media data, as part of the resource selection algorithm.
    public static var AUDIO_PROGRESS:String = "progress";     //The user agent is fetching media data.
    public static var AUDIO_SUSPEND:String = "suspend";  //The user agent is intentionally not currently fetching media data, but does not have the entire media resource downloaded.
    public static var AUDIO_ABORT:String = "abort";    //The user agent stops fetching the media data before it is completely downloaded, but not due to an error.
    public static var AUDIO_ERROR:String = "error";    //An error occurs while fetching the media data.
    public static var AUDIO_EMPTIED:String = "emptied";  //A media element whose networkState was previously not in the NETWORK_EMPTY state has just switched to that state (either because of a fatal error during load that's about to be reported, or because the load() method was invoked while the resource selection algorithm was already running).
    public static var AUDIO_STALLED:String = "stalled";  //The user agent is trying to fetch media data, but data is unexpectedly not forthcoming.
    public static var AUDIO_PLAY:String = "play";     //Playback has begun. Fired after the play() method has returned, or when the autoplay attribute has caused playback to begin.
    public static var AUDIO_PAUSE:String = "pause";    //Playback has been paused. Fired after the pause() method has returned.
    public static var AUDIO_LOADEDMETADATA:String = "loadedmetadata";   //The user agent has just determined the duration and dimensions of the media resource
    public static var AUDIO_LOADEDDATA:String = "loadeddata";   //The user agent can render the media data at the current playback position for the first time.
    public static var AUDIO_WAITING:String = "waiting";  //Playback has stopped because the next frame is not available, but the user agent expects that frame to become available in due course.
    public static var AUDIO_PLAYING:String = "playing";  //Playback has started.
    public static var AUDIO_CANPLAY:String = "canplay";  //The user agent can resume playback of the media data, but estimates that if playback were to be started now, the media resource could not be rendered at the current playback rate up to its end without having to stop for further buffering of content.
    public static var AUDIO_CANPLAYTHROUGH:String = "canplaythrough";   //The user agent estimates that if playback were to be started now, the media resource could be rendered at the current playback rate all the way to its end without having to stop for further buffering.
    public static var AUDIO_SEEKING:String = "seeking";  //The seeking IDL attribute changed to true and the seek operation is taking long enough that the user agent has time to fire the event.
    public static var AUDIO_SEEKED:String = "seeked";   //The seeking IDL attribute changed to false.
    public static var AUDIO_TIMEUPDATE:String = "timeupdate";   //The current playback position changed as part of normal playback or in an especially interesting way, for example discontinuously.
    public static var AUDIO_ENDED:String = "ended";    //Playback has stopped because the end of the media resource was reached.
    public static var AUDIO_RATECHANGE:String = "ratechange";   //Either the defaultPlaybackRate or the playbackRate attribute has just been updated.
    public static var AUDIO_DURATIONCHANGE:String = "durationchange";   //The duration attribute has just been updated.
    public static var AUDIO_VOLUMECHANGE:String = "volumechange";     //Either the volume attribute or the muted attribute has changed. Fired after the relevant attribute's setter has returned.

    public var data:AudioData;

    public function new(type:String,data:AudioData)
    {
        super(type);

        this.data = data;
    }
}

