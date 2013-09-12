package playmachine.application;

import js.Dom;
import js.Lib;
import haxe.xml.Parser;
import haxe.xml.Fast;

class PlayMachine extends Application
{
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
	override public static function main():Void
	{
#if flash
		new PlayMachine(loaderInfo.parameters.init);
#end
	}

	/**
	 * declare the playmachine components
	 */
	override private function declareComponents():Void
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

}