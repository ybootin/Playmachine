package playmachine.core;

import js.html.HtmlElement;
import playmachine.event.IEventDispatcher;

interface IApplication extends IEventDispatcher
{
    private var data:Dynamic;

    private var components:Array<IComponent>;

    private var rootNode:HtmlElement;

    private function declareComponents():Void;

    private function initComponents():Void;
    private function parseTemplate(tmpl:String):Void;

}