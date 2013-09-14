package playchine.helpers;


class HashHelper
{
    public static function toHash(d:Dynamic):Map {
        var h = new Map();
        for (field in Reflect.fields(d)) {
             var value:String = Reflect.field(d, field);
             h.set(field, value);
        }
        return h;
    }
}