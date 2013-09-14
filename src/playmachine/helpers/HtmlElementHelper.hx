package playmachine.helpers;

import js.Browser;
import js.html.Event;
import js.html.Element;
import js.html.Node;
import js.html.MouseEvent;

class ElementHelper {


    public static function getElementByClassName(elt:Element, name:String):Node {
        var a = elt.getElementsByClassName(name);
        return a[0];
    }

    public static function getClassNames(elt:Element):Array<String> {
        var classes = elt.className;
        if (classes == null)
            return new Array<String>();
        return classes.split(" ");
    }

    public static function addClass(element:Element, className:String):Element {
        if (element.className.indexOf(className) == -1) {
            element.className += ' ' + className;
        }
        return element;
    }
    public static function removeClass(element:Element, className:String):Element {
        if (element.className.indexOf(className) >= 0) {
            element.className = StringTools.replace(element.className, className, '');
            element.className = StringTools.trim(element.className);
        }
        return element;
    }
    public static function toggleClass(element:Element, className:String):Element {
        if (element.className.indexOf(className) == -1) {
            return addClass(element,className);
        }
        else {
            return removeClass(element,className);
        }
    }

    public static function replaceClass(elt:Element,currentClass:String,newClass:String):Element {
        removeClass(elt,currentClass);
        return addClass(elt,newClass);
    }

    /**
     * text or comment are proper Element instances but are missing the getAttribute() method!
     */
    public static function getChildElements(elt:Element):List<Element> {
        var children = new List<Element>();
        var i;
        for (i in 0...elt.childNodes.length) {
            var child = elt.childNodes[i];
            // Only look for element nodes
            if (child.nodeType == 1) {
                children.add(child);
            }
        }

        return children;
    }

    public static function getOffset(el:Element):Array<Int> {
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
                el = el.offsetParent;
            }
            catch (e:Dynamic) {
                break;
            }
        }
        return [_x, _y];
    }

    public static function getPercentClick(el:Element,evt:MouseEvent):Float
    {
        var offset:Array<Int> = getOffset(el);
        var realX:Float = evt.clientX - offset[0];
        var percentClick:Float = realX / el.offsetWidth;

        return percentClick;
    }

    public static function appendSWF(elt:Element,src:String,width:Int,height:Int):Void
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
