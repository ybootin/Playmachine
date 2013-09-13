package;

import js.html.HtmlElement;
import js.Browser;
import haxe.Resource;

@:expose class Test
{
    private var rootNode:HtmlElement;

#if js
    public function new(container:HtmlElement)
    {
        //js boot specific
        rootNode = container;
#elseif flash
    public function new()
    {
#end
        parseTemplate();
    }

    public static function main()
    {
#if flash
        new Test();
#end
    }

    private function parseTemplate():Void
    {
        var xml:Xml = Xml.parse(Resource.getString('template'));

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
#else
        //init cocktail, and starts the load of the "index.html" file
        cocktail.api.Cocktail.boot();

        // IMPORTANT, do this otherwise the app will fit to the swf-header width/height
        flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;

        //when document is loaded, set the content of the body
        Browser.window.onload = function(e) {
            Browser.document.body.innerHTML = body;
            rootNode = Browser.document.body;
        }
#end
    }
}