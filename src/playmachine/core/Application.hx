package playmachine.core;

#if js
import playmachine.event.EventDispatcher;
#else
import flash.events.EventDispatcher;
#end
import playmachine.event.ApplicationEvent;
import playmachine.event.ErrorEvent;

import playmachine.core.IComponent;

import js.Browser;
import js.html.HtmlElement;

import haxe.Resource;
import haxe.Json;


class Application extends EventDispatcher implements IApplication
{
    private static var TEMPLATE_RESOURCE_NAME:String = 'template';

    public var data:Dynamic;

    public var components:Array<IComponent>;

    private var rootNode:HtmlElement;

    @:isVar public var debug(default,set):Bool;

#if js
    public function new(container:HtmlElement,data:Dynamic,?eventHandler:Dynamic = null)
    {
        super();

        //js boot specific
        rootNode = container;

        this.data = data;
#elseif flash
    public function new(data:Dynamic)
    {
        super();

        // Better trace
        haxe.Log.trace = playmachine.helpers.LogHelper.trace;

        this.data = Json.parse(data);
#end

        var debug:Bool = false;
        if(Reflect.hasField(data,'debug')) {
            debug = Reflect.field(data,'debug');
        }

        set_debug(true);

        var tmpl:String;
        if(Reflect.hasField(data,'template') && Reflect.field(data,'template') != null) {
            tmpl = Reflect.field(data,'template');
        }
        else {
            tmpl = Resource.getString(TEMPLATE_RESOURCE_NAME);
        }

        parseTemplate(tmpl);
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
        declareComponents();

        //init component after all are instanciated
        for(i in 0...components.length) {
            try {
                components[i].init();
            }
            catch(e:Dynamic) {
                trace('error init component ' + e);
            }

        }

        dispatchEvent(new ApplicationEvent(ApplicationEvent.APPLICATION_READY));
    }

    private function parseTemplate(tmpl:String):Void
    {
        var xml:Xml = Xml.parse(tmpl);

        var body:String = "";
        for(node in xml.elementsNamed('html')) {

            for(hnode in node.elementsNamed('head')) {
                for(lnode in hnode.elementsNamed('link')) {
                    body += lnode.toString();
                }
                for(snode in hnode.elementsNamed('style')) {
                    body += snode.toString();
                }
            }
            for(bnode in node.elementsNamed('body')) {
                body += bnode.toString();
            }
        }
#if js
        rootNode.innerHTML = body;
        initComponents();
#else
        //init cocktail
        cocktail.api.Cocktail.boot();

#if flash
        // IMPORTANT, do this otherwise the app will fit to the swf-header width/height
        flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
#end
        //when document is loaded, set the content of the body
        Browser.window.onload = function(e) {
            Browser.document.body.innerHTML = body;
            rootNode = Browser.document.body;

            initComponents();
        }
#end
    }

    public function appendChild(elt:HtmlElement):Void
    {
        rootNode.appendChild(elt);
    }

    /**
     * Haxe 3 setter
     * @param activate [description]
     */
    private function set_debug(activate:Bool):Bool
    {
        debug = activate;
        playmachine.helpers.LogHelper.debug = activate;

        return activate;
    }
}
