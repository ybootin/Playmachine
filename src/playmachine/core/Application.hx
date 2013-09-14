package playmachine.core;

import playmachine.event.EventDispatcher;
import playmachine.event.ApplicationEvent;
import playmachine.core.IComponent;

import js.Browser;
import js.html.HtmlElement;

import haxe.Resource;


class Application extends EventDispatcher implements IApplication
{
    private static inline var TEMPLATE_RESOURCE_NAME:String = 'template';

    public var data:Dynamic;

    public var components:Array<IComponent>;

    private var rootNode:HtmlElement;

#if js
    public function new(container:HtmlElement,data:Dynamic,?eventHandler:Dynamic = null)
    {
        super();

        //js boot specific
        rootNode = container;
#elseif flash
    public function new(data:Dynamic)
    {
        // Better trace
        haxe.Log.trace = playmachine.helpers.LogHelper.trace;
#end

        this.data = data;

        var tmpl:String;
        if(data.template != null) {
            tmpl = data.template;
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
            components[i].init();
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
}