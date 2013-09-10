package application.core;

import js.Dom;
import js.Lib;
import application.helpers.HtmlDomHelper;
using application.helpers.HtmlDomHelper;
import haxe.Json;
import application.core.Logger;
import application.core.Application;


/**
 * The base component
 */
package playmachine.model;

class Component
{
    private var global:EventDispatcher;

    private var element:HtmlDom;

    private var stylesAreInitiated:Bool;

    /**
     * The base data :
     *     js : application.init(node,data)
     *     flash : flashvars : "init=json-stringified data"
     */
    public var data:Dynamic;

    /**
     * here we set the data for js and flash, so each component will have access to data before init
     */
    public function new(nodeClassName:String,data:Dynamic) 
    {
    	try {
    		element = Lib.document.getElementsByClassName(nodeClassName)[0];
    	}
    	catch(e:Dynamic) {
    		// to do, handle errors
    	}

        this.data 	= data;

        global = new EventDispatcher();

    }

    /**
     * The basic init component, must be override by each component
     */
    override public function init():Void
    {
        initStyles();
    }

    /**
     * get an Html element using its name
     * @param  {String} name: Name of the element
     * @return {HtmlDom}              The element
     */
    public function getElementByName(name:String):HtmlDom
    {
        return element.getElementByClassName(name);
    }

    /**
     * dispatch an event on the group element
     * @param  {String} eventName: Name of the event
     * @param  {Dynamic} data:     data associated with the event
     * @return {Void}
     */
    public function dispatchEventOnGroup(eventName:String, ?eventData:Dynamic):Void
    {
        global.dispatchCustomEvent(eventName, eventData);
    }

    // FIXME : to be removed, styles will be loaded by http !
    public function initStyles():Void
    {
        if(!stylesAreInitiated) {
            stylesAreInitiated = true;

//fullsize app, that's what we want
// FIXME, check if we can override this with css stylesheet
#if flash
            js.Lib.document.body.style.marginTop = "0";
            js.Lib.document.body.style.marginLeft = "0";
            js.Lib.document.body.style.marginRight = "0";
            js.Lib.document.body.style.marginBottom = "0";
            js.Lib.document.documentElement.style.overflowX = "hidden";
            js.Lib.document.documentElement.style.overflowY = "hidden";
#end

            //use our template system with the stylesheet as ressource
            var css:String = haxe.Resource.getString('styles');

            if(css != null) {}
	            var style = js.Lib.document.createElement('style');

	            var textNode = js.Lib.document.createTextNode(css);
	            style.appendChild(textNode);

	            element.appendChild(style);
	          }
        }
    }
}
