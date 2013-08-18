package playmachine.audio;

class AudioManager extends BaseComponent
{
    var audio:HtmlDom;

    public function init():Void
    {
        audio = rootElement.getElementByName('audio');

        groupElement.addEventListener(Events.PLAY_TRACK_REQUEST,cast(onPlayRequest),false);
    }

    private function onPlayRequest(e:Event):Void
    {
        var t:Track = cast(e.detail);
        audio.setAttribute('src',t.file);
        audio.play();
    }
}