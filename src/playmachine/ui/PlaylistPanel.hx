package playmachine.ui;

import playmachine.event.HTML5AudioEvents;
import application.helpers.HtmlDomHelper;
using application.helpers.HtmlDomHelper;
import playmachine.data.Track;
import application.core.BaseComponent;
import playmachine.event.Events;
import js.Lib;
import js.Dom;
import haxe.Json;
import haxe.Template;
import haxe.Resource;
import application.core.Logger;

class PlaylistPanel extends BaseComponent
{
    /**
     * Holds the defaults html template for a track
     */
    private var template:String;

    private var tracks:Hash<Track>;
    private var currentTrack:Track;

    private var tracksElement:Hash<HtmlDom>;

    override public function init():Void
    {
        super.init();

        //setup the current template base noe content
        template = rootElement.innerHTML;
        rootElement.innerHTML = "";

        tracks = new Hash();
        tracksElement = new Hash();

        groupElement.addEventListener(Events.ADD_TRACK_REQUEST,cast(onAddTrackRequest),false);
        groupElement.addEventListener(Events.PLAY_TRACK_REQUEST,cast(onPlayRequest),false);
        groupElement.addEventListener(Events.REMOVE_TRACK_REQUEST,cast(onRemoveRequest),false);


        // init the tracks
        if(data.tracks != null) {
            for(i in 0...data.tracks.length) {
                dispatchEventOnGroup(Events.ADD_TRACK_REQUEST,data.tracks[i]);
            }
        }
    }

    private function addTrack(t:Track):Void
    {
        var tpl:Template = new Template(template);
        var e:HtmlDom = Lib.document.createElement('div');
        e.innerHTML = tpl.execute({title:t.title,id:t.id});

        var onTrackClick = function(evt:Event):Void {
            if(tracks.exists(cast(t.id))) {
                dispatchEventOnGroup(Events.PLAY_TRACK_REQUEST,t);
            }
        }

        var removeButton:HtmlDom = e.getElementByClassName('remove');
        removeButton.addEventListener('click',function(evt:Event):Void {
            dispatchEventOnGroup(Events.REMOVE_TRACK_REQUEST,t);

            //remove the handler to avoid the click to be dispatched to the child element
            e.removeEventListener('click',onTrackClick,false);
        },true);

        e.addEventListener('click',onTrackClick,false);

        // add track to the stack
        tracks.set(cast(t.id),t);
        tracksElement.set(cast(t.id),e);

        rootElement.appendChild(e);
    }

    private function onRemoveRequest(e:CustomEvent):Void
    {
        var t:Track = cast(e.detail);

        tracks.remove(cast(t.id));
        rootElement.removeChild(tracksElement.get(cast(t.id)));
    }

    private function onPlayRequest(e:CustomEvent):Void
    {
        currentTrack = cast(e.detail);
    }

    private function onAddTrackRequest(e:CustomEvent):Void
    {
        var t:Track = cast(e.detail);
        addTrack(t);
    }
}