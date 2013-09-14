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

            if (ExternalInterface.available) {
                ExternalInterface.call('console.log', '[' + APPLICATION_NAME + '] ' + msg);
            }
            else {
                trace('[' + APPLICATION_NAME + '] ' + msg);
            }
        }
    }
}