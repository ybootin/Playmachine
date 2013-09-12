package playmachine.application;

import playmachine.event.EventDispatcher;
import playmachine.model.IComponent;

import js.Dom;
import js.Lib;

import haxe.xml.Parser;
import haxe.xml.Fast;

class Application extends EventDispatcher, implements IApplication
{
    private static inline var TEMPLATE_RESOURCE_NAME:String = 'template';

    private var data:Dynamic;

    private var components:Array<IComponent>;

    private var rootNode:HtmlDom;

#if js
    public function new(container:HtmlDom,data:Dynamic)
    {
        //js boot specific
#elseif flash
    public function new(data:Dynamic)
    {
        //flash boot specific
        var rootNode:HtmlDom = Lib.document.body;
#end

        this.data = data;

        declareComponents();
        initComponents();

        var tmpl:String;
        if(data.template != null) {
            tmpl = data.template;
        }
        else {
            tmpl = Resource.getString(TEMPLATE_RESOURCE_NAME);
        }

        parseTemplate(tmpl);

        // Honey, the app is ready !
        dispatchEvent(new ApplicationEvent('ready'));
    }


    /**
     * HaXe bootstrap , to be override
     *
     * for flash autostart just start a new Application(loaderInfo.parameters.init)
     */
    public static function main():Void
    {
        //to be override
    }

    /**
     * just declare the components, to be override to include components
     */
    private function declareComponents():Void
    {
        components = [];
    }

    private function initComponents():Void
    {
        //init component after all are instanciated
        for(i in 0...components.length) {
            components[i].init();
        }
    }

    private function parseTemplate(tmpl:String):Void
    {
        var xml:Xml = Parser.parse(tmpl);
        var fast:Fast = new Fast(xml);

        var stylesheets:Array<String> = [];
        // parse head, and retrieve stylesheets (and script for js)

        // retrieve the body, inject the styles sheets, and append root node
        var body:String = fast.node.html.node.body.toString();

        rootNode.innerHTML = body;
    }
}