package playmachine.helpers;

#if flash
import flash.external.ExternalInterface;
#end

class LogHelper
{
    public static var APPLICATION_NAME:String = "application";

    public static var debug:Bool;

    /**
     * avoid trace directly in flash, better use js console
     *
     * @param  {[type]} msg    : Dynamic       [description]
     * @param  {[type]} ?infos : haxe.PosInfos [description]
     */
    public static function trace(msg : Dynamic, ?infos : haxe.PosInfos):Void
    {
        if(debug) {
            if (infos != null) {
                msg = infos.fileName + ':' + infos.lineNumber + ': ' + msg + ' (' + infos.className + '.' + infos.methodName + ')';
            }
#if flash
            if (ExternalInterface.available) {
                ExternalInterface.call('console.log', '[' + APPLICATION_NAME + '] ' + msg);
            }
            else {
                trace('[' + APPLICATION_NAME + '] ' + msg);
            }
#else
            untyped console.log('[' + APPLICATION_NAME + '] ' + msg);
#end
        }
    }

    /**
     * Force a trace, even is debug is not activated
     * @param  msg [description]
     * @return     [description]
     */
    public static function forceTrace(msg):Void
    {
        if(debug) {
            trace(msg);
            return;
        }

        debug = true;
        trace(msg);
        debug = false;
    }
}