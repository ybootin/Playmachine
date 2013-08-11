package playmachine.helper;



class HtmlDomHelper {


    public static function getElementByClassName(elt:HtmlDom, name:String):HtmlDom {
        var a = elt.getElementsByClassName(name);
        Util.assert(a.length == 1, "Expecting one match for class " + name + ", got " + a.length);
        return a[0];
    }

    public static function dispatchCustomEvent(elt:HtmlDom, eventName:String, ?data:Dynamic) {
        var e:CustomEvent = cast(Lib.document.createEvent("CustomEvent"));
        e.initCustomEvent(eventName, false, false, data);
        elt.dispatchEvent(e);
    }

    public static function getClassNames(elt:HtmlDom):Array<String> {
        var classes = elt.className;
        if (classes == null)
            return new Array<String>();
        return classes.split(" ");
    }

    public static function addClass(element:HtmlDom, className:String):HtmlDom {
        if (element.className.indexOf(className) == -1) {
            element.className += ' ' + className;
        }
        return element;
    }
    public static function removeClass(element:HtmlDom, className:String):HtmlDom {
        if (element.className.indexOf(className) >= 0) {
            element.className = StringTools.replace(element.className, className, '');
            element.className = StringTools.trim(element.className);
        }
        return element;
    }
    public static function toggleClass(element:HtmlDom, className:String):HtmlDom {
        if (element.className.indexOf(className) == -1) {
            return addClass(element,className);
        }
        else {
            return removeClass(element,className);
        }
    }

    public static function replaceClass(elt:HtmlDom,currentClass:String,newClass:String):HtmlDom {
        removeClass(elt,currentClass);
        return addClass(elt,newClass);
    }


    /**
     * text or comment are proper HtmlDom instances but are missing the getAttribute() method!
     */
    public static function getChildElements(elt:HtmlDom):List<HtmlDom> {
        var children = new List<HtmlDom>();
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
}
