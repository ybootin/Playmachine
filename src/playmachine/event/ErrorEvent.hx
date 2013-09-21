package playmachine.event;

import playmachine.event.Event;

class ErrorEvent extends Event
{
    public static var ERROR:String = 'error';

    public var errorData:Dynamic;
    public var exception:Dynamic;

    public function new(msg:String,errorData:Dynamic,?exception:Dynamic = null)
    {
        super(ERROR);
        this.errorData = errorData;
        this.exception = exception;
    }
}