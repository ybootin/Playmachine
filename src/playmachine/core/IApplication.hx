package playmachine.core;

import js.html.HtmlElement;

#if js
import playmachine.event.IEventDispatcher;
#else
import flash.events.IEventDispatcher;
#end

interface IApplication extends IEventDispatcher
{
    public var data:Dynamic;

    public var components:Array<IComponent>;

    private var rootNode:HtmlElement;

    private function declareComponents():Void;

    private function initComponents():Void;
    private function parseTemplate(tmpl:String):Void;

}