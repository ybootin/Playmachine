package playchine.helper;

class HashHelper
{
    public static function toHash(d:Dynamic):Hash<String> {
        var h = new Hash<String>();
        for (field in Reflect.fields(d)) {
             var value:String = Reflect.field(d, field);
             h.set(field, value);
        }
        return h;
    }
}