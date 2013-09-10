package playmachine.ui;

import playmachine.event.HTML5AudioEvents;
import playmachine.data.Track;
import application.model.Component;
import playmachine.event.Events;
import js.Lib;
import js.Dom;
import application.helpers.HtmlDomHelper;
using application.helpers.HtmlDomHelper;

/**
 * Display the track image
 */
class TrackImage extends Component
{
    var image:Image;

    override public function init():Void
    {
        if(Lib.document.getElementsByTagName('img').length > 0) {
            image = cast(Lib.document.getElementsByTagName('img')[0]);
        }
        else {
            image = cast(Lib.document.createElement('img'));
            element.appendChild(image);
        }

        global.addEventListener(Events.PLAY_TRACK_REQUEST,cast(onTrackChange),false);
    }

    private function hide():Void
    {
        image.style.display = "none";
    }

    private function show():Void
    {
        image.style.display = "block";
    }

    private function onTrackChange(evt:CustomEvent):Void
    {
        var t:Track = cast(evt.detail);
        var src:String = t.image;

        if(src == null || src.length == 0) {
            hide();
        }
        else {
            image.src = t.image;
            show();
        }
    }
}