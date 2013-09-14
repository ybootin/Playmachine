package playmachine.core;

import js.Browser;
import js.html.HtmlElement;

import playmachine.event.EventDispatcher;

class Component extends EventDispatcher implements IComponent
{
    private var element:HtmlElement;

    private var application:IApplication;

    /**
     * here we set the data for js and flash, so each component will have access to data before init
     */
    public function new(application:IApplication,?nodeClassName:String = null)
    {
        super();

        if(nodeClassName == null) {
            // no htmlElement for this component
        }
        else {
        	try {
        		element = Browser.document.getElementsByClassName(nodeClassName)[0];
        	}
        	catch(e:Dynamic) {
        		// no html element attached to node
        	}
        }
    }

    /**
     * The basic init component, must be override by each component
     */
    public function init():Void
    {

    }

    /**
     * get an Html element using its name
     * @param  {String} name: Name of the element
     * @return {HtmlElement}              The element
     */
    public function getElementByName(name:String):HtmlElement
    {
        return element.getElementByClassName(name);
    }
}
