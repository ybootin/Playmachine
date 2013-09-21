package playmachine.core;

import js.Browser;
import js.html.HtmlElement;

import playmachine.helpers.HtmlElementHelper;
using playmachine.helpers.HtmlElementHelper;
import playmachine.event.EventDispatcher;
import playmachine.event.ErrorEvent;

class Component extends EventDispatcher implements IComponent
{
    public var element:HtmlElement;

    public var application:IApplication;

    /**
     * here we set the data for js and flash, so each component will have access to data before init
     */
    public function new(application:IApplication,?nodeClassName:String = null)
    {
        super();

        this.application = application;

        if(nodeClassName == null) {
            element = cast(Browser.document.createElement('div'));
        }
        else {
        	try {
        		element = cast(Browser.document.getElementsByClassName(nodeClassName)[0]);
        	}
        	catch(e:Dynamic) {
        		// no html element attached to node
                dispatchError('WARNING, cannot use ' + nodeClassName + ' for component ' + Type.typeof(this) + ", HtmlElement doesn't exists in the DOM",e);
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
    public function getChildElement(className:String):HtmlElement
    {
        return element.getElementByClassName(className);
    }

    function dispatchError(msg:String,errorData:Dynamic):Void
    {
        trace(msg);
        //todo handle error
        //application.dispatchEvent(new ErrorEvent('error',errorData));
    }
}
