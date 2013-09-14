package playmachine.event;

#if js
import js.html.Event;
#else
import flash.events.Event;
#end

class ApplicationEvent extends Event
{
    public static inline var APPLICATION_READY:String = "ready";

    public var data:Dynamic;

    public function new(type:String,?data:Dynamic = null)
    {
        super(type);
        this.data = data;
    }
}

