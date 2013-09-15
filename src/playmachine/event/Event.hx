package playmachine.event;

class Event
{
    public var type:String;

    public function new(type:String,?bubbles:Bool = false,?cancelable:Bool)
    {
        this.type = type;
    }
}