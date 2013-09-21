package playmachine.event;

class PlaymachineEvent extends ApplicationEvent
{
    public static var NEXT_TRACK_REQUEST:String = 'nextTrackRequest';
    public static var PREVIOUS_TRACK_REQUEST:String = "previousTrackRequest";

    public static var ADD_TRACK_REQUEST:String = "addTrackRequest";
    public static var PLAY_TRACK_REQUEST:String = "playTrackRequest";
    public static var REMOVE_TRACK_REQUEST:String = "removeTrackRequest";

    public static var PLAY_REQUEST:String = "playRequest";
    public static var PAUSE_REQUEST:String = "pauseRequest";
    public static var SEEK_REQUEST:String = "seekRequest";
    public static var VOLUME_REQUEST:String = "volumeRequest";

    public static var AUDIO_READY:String = "audioReady";
}