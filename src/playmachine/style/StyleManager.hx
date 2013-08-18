package playmachine.style;

import js.Dom;
import js.Lib;
import buzzplayer.core.ComponentHelper;
using buzzplayer.core.ComponentHelper;
import haxe.Template;

class StyleManager extends BaseComponent {


    override public function init():Void {

#if flash
        js.Lib.document.body.style.marginTop = "0";
        js.Lib.document.body.style.marginLeft = "0";
        js.Lib.document.body.style.marginRight = "0";
        js.Lib.document.body.style.marginBottom = "0";
        js.Lib.document.documentElement.style.overflowX = "hidden";
        js.Lib.document.documentElement.style.overflowY = "hidden";
#end

        var style = js.Lib.document.createElement('style');

        //use our template system with the stylesheet as ressource
        var css:String = new Template(haxe.Resource.getString('style')).execute({});

        var textNode = js.Lib.document.createTextNode(css);
        style.appendChild(textNode);
    }
}
