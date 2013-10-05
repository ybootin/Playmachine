package playmachine.components;

import playmachine.event.AudioEvent;
import playmachine.data.AudioData;
import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;
import playmachine.data.Track;
import playmachine.core.Component;
import playmachine.event.PlaymachineEvent;

import haxe.Json;
import haxe.Template;
import haxe.Resource;
import haxe.ds.IntMap;

import js.html.HtmlElement;
import js.html.Event;
import js.html.MouseEvent;

import js.Browser;

class PlaylistPanel extends Component
{
    /**
     * Holds the defaults html template for a track
     */
    private var template:String;

    private var tracks:IntMap<Track>;
    private var currentTrack:Track;

    private var tracksPosition:Array<Int>;

    private var tracksElement:IntMap<HtmlElement>;

    override public function init():Void
    {
        super.init();

        //setup the current template base noe content
        template = element.innerHTML;
        element.innerHTML = "";

        tracks = new IntMap();
        tracksElement = new IntMap();
        tracksPosition = [];

        application.addEventListener(PlaymachineEvent.ADD_TRACK_REQUEST,onAddTrackRequest,false);
        application.addEventListener(PlaymachineEvent.PLAY_TRACK_REQUEST,onPlayRequest,false);
        application.addEventListener(PlaymachineEvent.REMOVE_TRACK_REQUEST,onRemoveRequest,false);
        application.addEventListener(PlaymachineEvent.NEXT_TRACK_REQUEST,onNextRequest,false);
        application.addEventListener(PlaymachineEvent.PREVIOUS_TRACK_REQUEST,onPreviousRequest,false);

        application.addEventListener(PlaymachineEvent.PLAY_REQUEST,function(evt:PlaymachineEvent):Void {
            if(currentTrack == null && tracksPosition.length > 0) {
                var t:Track = tracks.get(tracksPosition[0]);
                application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.PLAY_TRACK_REQUEST,t));
            }
        },false);

        // init the tracks
        if(application.data.tracks != null) {
            for(i in 0...application.data.tracks.length) {
                application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.ADD_TRACK_REQUEST,application.data.tracks[i]));
            }
        }
    }

    private function addTrack(t:Track):Void
    {
        var tpl:Template = new Template(template);
        var e:HtmlElement = cast(Browser.document.createElement('div'));
        e.innerHTML = tpl.execute({title:t.title,id:t.id});

        var onTrackClick = function(evt:MouseEvent):Void {
            if(tracks.exists(t.id)) {
                application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.PLAY_TRACK_REQUEST,t));
            }
        }

        var removeButton:HtmlElement = e.getElementByClassName('remove');
        removeButton.addEventListener('click',function(evt:Event):Void {
            application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.REMOVE_TRACK_REQUEST,t));

            //remove the handler to avoid the click to be dispatched to the child element
            e.removeEventListener('click',cast(onTrackClick),false);
        },true);

        e.addEventListener('click',cast(onTrackClick),false);

        // add track to the stack
        tracks.set(t.id,t);
        tracksElement.set(t.id,e);
        tracksPosition.push(t.id);

        element.appendChild(e);
    }

    private function onRemoveRequest(e:PlaymachineEvent):Void
    {
        var t:Track = cast(e.data);

        tracks.remove(t.id);
        element.removeChild(tracksElement.get(t.id));
        tracksElement.remove(t.id);
        tracksPosition.remove(t.id);
    }

    private function onPlayRequest(e:PlaymachineEvent):Void
    {
        if(currentTrack != null) {
            getTrackElement(currentTrack).removeClass('current');
        }

        currentTrack = cast(e.data);
        getTrackElement(currentTrack).addClass('current');
    }

    private function onAddTrackRequest(e:PlaymachineEvent):Void
    {
        var t:Track = cast(e.data);
        addTrack(t);
    }

    private function onNextRequest(e:PlaymachineEvent):Void
    {
        var pos:Int = Lambda.indexOf(tracksPosition,currentTrack.id);

        var next:Int = pos + 1;
        if(next == tracksPosition.length) {
            next = 0;
        }

        application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.PLAY_TRACK_REQUEST,tracks.get(tracksPosition[next])));
    }

    private function onPreviousRequest(e:PlaymachineEvent):Void
    {
        var pos:Int = Lambda.indexOf(tracksPosition,currentTrack.id);

        var prev:Int = pos - 1;
        if(prev < 0) {
            prev = tracksPosition.length - 1;
        }

        application.dispatchEvent(new PlaymachineEvent(PlaymachineEvent.PLAY_TRACK_REQUEST,tracks.get(tracksPosition[prev])));
    }

    private function getTrackElement(t:Track):HtmlElement
    {
        return tracksElement.get(t.id).getElementByClassName('track');
    }
}
