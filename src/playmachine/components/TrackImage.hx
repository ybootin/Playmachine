package playmachine.components;

import playmachine.event.AudioEvent;
import playmachine.data.Track;
import application.model.Component;
import playmachine.event.ApplicationEvent;
import js.Lib;
import js.Dom;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;

/**
 * Display the track image
 */
class TrackImage extends Component
{
    var image:Image;

    override public function init():Void
    {
        if(Browser.document.getElementsByTagName('img').length > 0) {
            image = cast(Browser.document.getElementsByTagName('img')[0]);
        }
        else {
            image = cast(Browser.document.createElement('img'));
            element.appendChild(image);
        }

        application.addEventListener(ApplicationEvent.PLAY_TRACK_REQUEST,cast(onTrackChange),false);
    }

    private function hide():Void
    {
        image.style.display = "none";
    }

    private function show():Void
    {
        image.style.display = "block";
    }

    private function onTrackChange(evt:ApplicationEvent):Void
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