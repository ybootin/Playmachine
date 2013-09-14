package playmachine.event;

class PlaymachineEvent extends ApplicationEvent
{
    public static inline var NEXT_TRACK_REQUEST:String = 'nextTrackRequest';
    public static inline var PREVIOUS_TRACK_REQUEST:String = "previousTrackRequest";

    public static inline var ADD_TRACK_REQUEST:String = "addTrackRequest";
    public static inline var PLAY_TRACK_REQUEST:String = "playTrackRequest";
    public static inline var REMOVE_TRACK_REQUEST:String = "removeTrackRequest";

    public static inline var PLAY_REQUEST:String = "playRequest";
    public static inline var PAUSE_REQUEST:String = "pauseRequest";
    public static inline var SEEK_REQUEST:String = "seekRequest";
    public static inline var VOLUME_REQUEST:String = "volumeRequest";

    public static inline var AUDIO_READY:String = "audioReady";
}