package;

import haxe.xml.Fast;
import haxe.xml.Parser;

import js.Dom;
import js.Lib;

import haxe.Resource;

class Test
{
    public function new()
    {
        var tmpl:String = Resource.getString('template');
        parseTemplate(tmpl);
    }

    public static function main()
    {
        new Test();
    }

    private function parseTemplate(tmpl:String):Void
    {
        untyped console.log('template',tmpl);

        var xml:Xml = Parser.parse(tmpl);
        var fast:Fast = new Fast(xml);

        var stylesheets:Array<String> = [];
        // parse head, and retrieve stylesheets (and script for js)

        // retrieve the body, inject the styles sheets, and append root node
        var body:String = fast.node.html.node.body.x.toString();
        var head:String = fast.node.html.node.head.x.toString();


        untyped console.log('body',body);
        untyped console.log('head',head);
    }
}