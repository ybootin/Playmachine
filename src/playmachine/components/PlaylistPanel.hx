package playmachine.components;

import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;
import playmachine.data.Track;
import application.model.Component;
import playmachine.event.ApplicationEvent;
import js.Lib;
import js.Dom;
import haxe.Json;
import haxe.Template;
import haxe.Resource;
import haxe.ds.IntHash;

class PlaylistPanel extends Component
{
    /**
     * Holds the defaults html template for a track
     */
    private var template:String;

    private var tracks:IntHash<Track>;
    private var currentTrack:Track;

    private var tracksPosition:Array<Int>;

    private var tracksElement:IntHash<HtmlElement>;

    override public function init():Void
    {
        super.init();

        //setup the current template base noe content
        template = element.innerHTML;
        element.innerHTML = "";

        tracks = new IntHash();
        tracksElement = new IntHash();
        tracksPosition = [];

        application.addEventListener(ApplicationEvent.ADD_TRACK_REQUEST,cast(onAddTrackRequest),false);
        application.addEventListener(ApplicationEvent.PLAY_TRACK_REQUEST,cast(onPlayRequest),false);
        application.addEventListener(ApplicationEvent.REMOVE_TRACK_REQUEST,cast(onRemoveRequest),false);
        application.addEventListener(ApplicationEvent.NEXT_TRACK_REQUEST,cast(onNextRequest),false);
        application.addEventListener(ApplicationEvent.PREVIOUS_TRACK_REQUEST,cast(onPreviousRequest),false);

        // init the tracks
        if(data.tracks != null) {
            for(i in 0...data.tracks.length) {
                dispatchEventOnGroup(ApplicationEvent.ADD_TRACK_REQUEST,data.tracks[i]);
            }
        }
    }

    private function addTrack(t:Track):Void
    {
        var tpl:Template = new Template(template);
        var e:HtmlElement = Browser.document.createElement('div');
        e.innerHTML = tpl.execute({title:t.title,id:t.id});

        var onTrackClick = function(evt:Event):Void {
            if(tracks.exists(t.id)) {
                dispatchEventOnGroup(ApplicationEvent.PLAY_TRACK_REQUEST,t);
            }
        }

        var removeButton:HtmlElement = e.getElementByClassName('remove');
        removeButton.addEventListener('click',function(evt:Event):Void {
            dispatchEventOnGroup(ApplicationEvent.REMOVE_TRACK_REQUEST,t);

            //remove the handler to avoid the click to be dispatched to the child element
            e.removeEventListener('click',onTrackClick,false);
        },true);

        e.addEventListener('click',onTrackClick,false);

        // add track to the stack
        tracks.set(t.id,t);
        tracksElement.set(t.id,e);
        tracksPosition.push(t.id);

        element.appendChild(e);
    }

    private function onRemoveRequest(e:ApplicationEvent):Void
    {
        var t:Track = cast(e.detail);

        tracks.remove(t.id);
        element.removeChild(tracksElement.get(t.id));
        tracksElement.remove(t.id);
        tracksPosition.remove(t.id);
    }

    private function onPlayRequest(e:ApplicationEvent):Void
    {
        if(currentTrack != null) {
            getTrackElement(currentTrack).removeClass('current');
        }

        currentTrack = cast(e.detail);
        getTrackElement(currentTrack).addClass('current');
    }

    private function onAddTrackRequest(e:ApplicationEvent):Void
    {
        var t:Track = cast(e.detail);
        addTrack(t);
    }

    private function onNextRequest(e:Event):Void
    {
        var pos:Int = Lambda.indexOf(tracksPosition,currentTrack.id);

        var next:Int = pos + 1;
        if(next == tracksPosition.length) {
            next = 0;
        }

        dispatchEventOnGroup(ApplicationEvent.PLAY_TRACK_REQUEST,tracks.get(tracksPosition[next]));
    }

    private function onPreviousRequest(e:Event):Void
    {
        var pos:Int = Lambda.indexOf(tracksPosition,currentTrack.id);

        var prev:Int = pos - 1;
        if(prev < 0) {
            prev = tracksPosition.length - 1;
        }

        dispatchEventOnGroup(ApplicationEvent.PLAY_TRACK_REQUEST,tracks.get(tracksPosition[prev]));
    }

    private function getTrackElement(t:Track):HtmlElement
    {
        return tracksElement.get(t.id).getElementByClassName('track');
    }
}