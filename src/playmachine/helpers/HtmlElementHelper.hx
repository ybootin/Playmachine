package playmachine.helpers;

import js.Browser;
import js.html.Event;
import js.html.Element;
import js.html.HtmlElement;
import js.html.Node;
import js.html.MouseEvent;

class HtmlElementHelper {


    public static function getElementByClassName(elt:HtmlElement, name:String):HtmlElement {
        var a = elt.getElementsByClassName(name);
        return cast(a[0]);
    }

    public static function getClassNames(elt:HtmlElement):Array<String> {
        var classes = elt.className;
        if (classes == null)
            return new Array<String>();
        return classes.split(" ");
    }

    public static function hasClass(elt:HtmlElement,className:String):Bool
    {
        return elt.getAttribute('class').indexOf(className) > -1;
    }

    public static function addClass(element:HtmlElement, className:String):HtmlElement {
        if (element.className.indexOf(className) == -1) {
            element.className += ' ' + className;
        }
        return element;
    }
    public static function removeClass(element:HtmlElement, className:String):HtmlElement {
        if (element.className.indexOf(className) >= 0) {
            element.className = StringTools.replace(element.className, className, '');
            element.className = StringTools.trim(element.className);
        }
        return element;
    }
    public static function toggleClass(element:HtmlElement, className:String):HtmlElement {
        if (element.className.indexOf(className) == -1) {
            return addClass(element,className);
        }
        else {
            return removeClass(element,className);
        }
    }

    public static function replaceClass(elt:HtmlElement,currentClass:String,newClass:String):HtmlElement {
        removeClass(elt,currentClass);
        return addClass(elt,newClass);
    }

    /**
     * text or comment are proper Element instances but are missing the getAttribute() method!
     */
    public static function getChildElements(elt:HtmlElement):List<HtmlElement> {
        var children = new List<HtmlElement>();
        var i;
        for (i in 0...elt.childNodes.length) {
            var child = elt.childNodes[i];
            // Only look for element nodes
            if (child.nodeType == 1) {
                children.add(cast(child));
            }
        }

        return children;
    }

    public static function getOffset(el:HtmlElement):Array<Int> {
        var _x = 0;
        var _y = 0;
        while (el != null)
        {
            //FIXME : due to a bug (we call offsetLeft before app is fully load)
            try {
                if (!Math.isNaN( el.offsetLeft ) && !Math.isNaN( el.offsetTop )) {
                    _x += el.offsetLeft;
                    _y += el.offsetTop;
                }
            }
            catch (e:Dynamic) {
                // continue
            }

            try {
                el = cast(el.offsetParent);
            }
            catch (e:Dynamic) {
                break;
            }
        }
        return [_x, _y];
    }

    public static function getPercentClick(el:HtmlElement,evt:MouseEvent):PercentClick
    {
        var offset:Array<Int> = getOffset(el);

        var output:PercentClick = {
            "width" : (evt.clientX - offset[0]) / el.offsetWidth,
            "height" : (evt.clientY - offset[1]) / el.offsetHeight
        };

        return output;
    }

    public static function appendSWF(elt:HtmlElement,src:String,width:Int,height:Int):Void
    {
#if js
        var params = {
            'allowFullScreen': true,
            'allowScriptAccess': 'always',
            'wmode': 'transparent',
            'scale': 'exactfit',
        };
        untyped {
            swfobject.embedSWF(
                src,
                elt.id,
                width,
                height,
                '10.2.0',
                null,
                null,
                params
            );
        }
#end
    }

}

typedef PercentClick = {
    width:Float,
    height:Float
}

