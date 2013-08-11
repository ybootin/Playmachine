package playmachine.event;

class PlayRequestEvent extends Event
{

    public static inline var PLAY_REQUEST:String = "playRequest";

    public var data:Track;

    public function new(t:Track)
    {
        data = t;
    }

}