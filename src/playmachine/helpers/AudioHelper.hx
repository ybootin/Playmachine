package playmachine.helpers;

import js.Dom;
import js.Lib;

class AudioHelper
{
    public static function getBufferPercent(audioElt:Audio):Float
    {
        var length:Int = audioElt.buffered.length;
        var start:Float;
        var end:Float;
        var total:Float = 0;

        for (i in 0...length) {
            start = audioElt.buffered.start(i);
            end = audioElt.buffered.end(i);
            total += (end - start);
        }

        var percent = 100 * total / audioElt.duration;

        return percent;
    }
}