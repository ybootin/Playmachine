package ebztracker.events;

/**
 * Very simple EventDispatcher class for HAXE
 */
class EventDispatcher extends IEventDispatcher
{
    /**
     * Holds the listeners function
     */
    private var listeners:Hash<Array<Dynamic>>;

    /**
     * Constructor
     *
     * target juste for cross compatibility, not used here
     * @param  ?target [description]
     * @return         [description]
     */
    public function new(?target:Dynamic)
    {
        listeners = new Hash();
    }

    public function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool = false):Void
    {
        if (!listeners.exists(type) || listeners.get(type) != listener) {
            if(!listeners.exists(type)) {
                listeners.set(type,[]);
            }
            var data:Array<Dynamic> = cast(listeners.get(type));
            data.push(listener);
            listeners.set(type,data);
        }
    }

    public function dispatchEvent(event:Event):Bool
    {
        var data:Array<Dynamic> = cast(listeners.get(event.type));

        if (data != null) {
            for(i in 0...data.length) {
                data[i](cast(event));
            }
        }

        return true;
    }

    /**
     * remove a previously added listener
     */
    public function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool = false):Void
    {

        if(listeners.exists(type)) {
            var data:Array<Dynamic> = cast(listeners.get(type));

            if(Lambda.has(data,listener)) {
                data.remove(listener);
            }

            listeners.set(type,data);
        }
    }

}

/**
 * just for flash compilation compatibility
 */
class IEventDispatcher {}