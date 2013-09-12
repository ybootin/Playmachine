package playmachine.model;


interface IApplication
{
    private var data:Dynamic;

    private var components:Array<IComponent>;

    private var rootNode:HtmlDom;

    public function new(container:HtmlDom,data:Dynamic);

    private function declareComponents():Void;

    public static function main():Void;
    private function initComponents():Void;
    private function parseTemplate(tmpl:String):Void;

}