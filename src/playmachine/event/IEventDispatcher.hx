package playmachine.event;

#if js
import playmachine.event.Event;
#else
import flash.events.Event;
#end


/**
 * Very simple EventDispatcher class for HAXE
 */
interface IEventDispatcher
{
    /**
     * Holds the listeners function
     */
    private var listeners:Map<String,Dynamic>;


    public function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool = false):Void;


    public function dispatchEvent(event:Event):Bool;


    /**
     * remove a previously added listener
     */
    public function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool = false):Void;

}
