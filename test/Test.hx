package;

import haxe.xml.Fast;
import haxe.xml.Parser;

import js.Dom;
import js.Lib;

import haxe.Resource;

class Test
{
    private var rootNode:HtmlDom;

#if js
    public function new(container:HtmlDom)
    {
        //js boot specific
        rootNode = container;
#elseif flash
    public function new()
    {
        //flash boot specific
        var rootNode:HtmlDom = cast(Lib.document.createElement('div'));
        Lib.document.body.appendChild(rootNode);
#end

        trace(rootNode);
        var tmpl:String = Resource.getString('template');
        parseTemplate(tmpl);
    }

    public static function main()
    {
#if flash
        new Test();
#end
    }

    private function parseTemplate(tmpl:String):Void
    {
        trace(tmpl);

        var xml:Xml = Parser.parse(tmpl);
        var fast:Fast = new Fast(xml);

        var stylesheets:Array<String> = [];
        // parse head, and retrieve stylesheets (and script for js)

        // retrieve the body, inject the styles sheets, and append root node
        var body:String = fast.node.html.node.body.x.toString();
        var head = fast.node.html.node.head;

        if (head.hasNode.style) {
            for(tag in head.nodes.style) {
                body += tag.x.toString();
            }
        }

        if (head.hasNode.link) {
            for(tag in head.nodes.link) {
                if(tag.has.rel && tag.has.href && tag.att.rel == "stylesheet") {
                    body += tag.x.toString();
                }
            }
        }
#if js
        rootNode.innerHTML = body;
#else
        rootNode.innerHTML = StringTools.urlDecode(body);
#end
    }
}