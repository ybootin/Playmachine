package playmachine.event;

class PlayRequestEvent extends Event
{

    public var data:Track;

    public function new(t:Track)
    {
        data = t;
    }

}