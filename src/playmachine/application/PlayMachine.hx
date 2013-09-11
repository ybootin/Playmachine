package playmachine.application;

import js.Dom;
import js.Lib;
import haxe.xml.Parser;
import haxe.xml.Fast;

class PlayMachine extends Application
{
	private static inline var TEMPLATE_RESOURCE_NAME:String = 'template';

	private var data:Dynamic;

	private var components:Array<IComponent>;

	private var rootNode:HtmlDom;

#if js
	public function new(container:HtmlDom,data:Dynamic)
	{
		//js boot specific
#elseif flash
	public function new(data:Dynamic)
	{
		//flash boot specific
		var rootNode:HtmlDom = Lib.document.body;
#end

		this.data = data;

		declareComponents();
		initComponents();

		var tmpl:String;
		if(data.template != null) {
			tmpl = data.template;
		}
		else {
			tmpl = Resource.getString(TEMPLATE_RESOURCE_NAME);
		}

		parseTemplate(tmpl);

		// Honey, the app is ready !
		dispatchEvent(new ApplicationEvent('ready'));
	}

	/**
	 * JS current init
	 */
	public static function init(container:HtmlDom,data:Dynamic):Void
	{
		return new PlayMachine(container,data);
	}

	/**
	 * HaXe bootstrap
	 */
	public static function main():Void
	{
#if flash
		new PlayMachine(loaderInfo.parameters.init);
#end
	}

	private function declareComponents():Void
	{
		// Store components className and order
		components = [
			new application.components.AudioManager(this,'AudioManager'),
			new application.components.ControlBar(this,'controlBar'),
			new application.components.PlaylistPanel(this,'PlaylistPanel'),
			new application.components.SeekBar(this,'SeekBar'),
			new application.components.TrackImage(this,'TrackImage')
		];
	}

	private function initComponents():Void
	{
		//init component after all are instanciated
		for(i in 0...components.length) {
			components[i].init();
		}
	}

	private function parseTemplate(tmpl:String):Void
	{
		var xml:Xml = Parser.parse(tmpl);
		var fast:Fast = new Fast(xml);

		var stylesheets:Array<String> = [];
		// parse head, and retrieve stylesheets (and script for js)

		// retrieve the body, inject the styles sheets, and append root node
		var body:String = fast.node.html.node.body.toString();

		rootNode.innerHTML = body;
	}
}