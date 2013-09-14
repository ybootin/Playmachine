package playmachine.helpers;

import js.Browser;
import js.html.Event;
import js.html.Audio;

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

    public static function hasMP3(audioElt:Audio):Bool
    {
        return false; //!!(audio.canPlayType && audio.canPlayType('audio/mpeg;').replace(/no/, ''));
    }
}