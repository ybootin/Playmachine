(function () { "use strict";
var $hxClasses = {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
$hxClasses["EReg"] = EReg;
EReg.__name__ = ["EReg"];
EReg.prototype = {
	customReplace: function(s,f) {
		var buf = new StringBuf();
		while(true) {
			if(!this.match(s)) break;
			buf.b += Std.string(this.matchedLeft());
			buf.b += Std.string(f(this));
			s = this.matchedRight();
		}
		buf.b += Std.string(s);
		return buf.b;
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matchedRight: function() {
		if(this.r.m == null) throw "No string matched";
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	,matchedLeft: function() {
		if(this.r.m == null) throw "No string matched";
		return this.r.s.substr(0,this.r.m.index);
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,r: null
	,__class__: EReg
}
var Hash = function() {
	this.h = { };
};
$hxClasses["Hash"] = Hash;
Hash.__name__ = ["Hash"];
Hash.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += Std.string("{");
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += Std.string(" => ");
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += Std.string(", ");
		}
		s.b += Std.string("}");
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,h: null
	,__class__: Hash
}
var HxOverrides = function() { }
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
}
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
	case 10:
		var k = s.split("-");
		return new Date(k[0],k[1] - 1,k[2],0,0,0);
	case 19:
		var k = s.split(" ");
		var y = k[0].split("-");
		var t = k[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw "Invalid date format : " + s;
	}
}
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var IntHash = function() {
	this.h = { };
};
$hxClasses["IntHash"] = IntHash;
IntHash.__name__ = ["IntHash"];
IntHash.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += Std.string("{");
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += Std.string(" => ");
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += Std.string(", ");
		}
		s.b += Std.string("}");
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,h: null
	,__class__: IntHash
}
var IntIter = function(min,max) {
	this.min = min;
	this.max = max;
};
$hxClasses["IntIter"] = IntIter;
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,max: null
	,min: null
	,__class__: IntIter
}
var Lambda = function() { }
$hxClasses["Lambda"] = Lambda;
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
Lambda.iter = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.fold = function(it,f,first) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !$iterator(it)().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = $iterator(a)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = $iterator(b)();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
var List = function() {
	this.length = 0;
};
$hxClasses["List"] = List;
List.__name__ = ["List"];
List.prototype = {
	map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,join: function(sep) {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s.b += Std.string(sep);
			s.b += Std.string(l[0]);
			l = l[1];
		}
		return s.b;
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.b += Std.string("{");
		while(l != null) {
			if(first) first = false; else s.b += Std.string(", ");
			s.b += Std.string(Std.string(l[0]));
			l = l[1];
		}
		s.b += Std.string("}");
		return s.b;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,length: null
	,q: null
	,h: null
	,__class__: List
}
var Reflect = function() { }
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && (v.__name__ || v.__ename__);
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
var Std = function() { }
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	toString: function() {
		return this.b;
	}
	,addSub: function(s,pos,len) {
		this.b += HxOverrides.substr(s,pos,len);
	}
	,addChar: function(c) {
		this.b += String.fromCharCode(c);
	}
	,add: function(x) {
		this.b += Std.string(x);
	}
	,b: null
	,__class__: StringBuf
}
var StringTools = function() { }
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += HxOverrides.substr(c,0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += HxOverrides.substr(c,0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
}
StringTools.isEOF = function(c) {
	return c != c;
}
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { }
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	HxOverrides.remove(a,"__name__");
	HxOverrides.remove(a,"__interfaces__");
	HxOverrides.remove(a,"__properties__");
	HxOverrides.remove(a,"__super__");
	HxOverrides.remove(a,"prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.slice();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
var haxe = {}
haxe.Unserializer = function(buf) {
	this.buf = buf;
	this.length = buf.length;
	this.pos = 0;
	this.scache = new Array();
	this.cache = new Array();
	var r = haxe.Unserializer.DEFAULT_RESOLVER;
	if(r == null) {
		r = Type;
		haxe.Unserializer.DEFAULT_RESOLVER = r;
	}
	this.setResolver(r);
};
$hxClasses["haxe.Unserializer"] = haxe.Unserializer;
haxe.Unserializer.__name__ = ["haxe","Unserializer"];
haxe.Unserializer.initCodes = function() {
	var codes = new Array();
	var _g1 = 0, _g = haxe.Unserializer.BASE64.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes[haxe.Unserializer.BASE64.charCodeAt(i)] = i;
	}
	return codes;
}
haxe.Unserializer.run = function(v) {
	return new haxe.Unserializer(v).unserialize();
}
haxe.Unserializer.prototype = {
	unserialize: function() {
		switch(this.buf.charCodeAt(this.pos++)) {
		case 110:
			return null;
		case 116:
			return true;
		case 102:
			return false;
		case 122:
			return 0;
		case 105:
			return this.readDigits();
		case 100:
			var p1 = this.pos;
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c >= 43 && c < 58 || c == 101 || c == 69) this.pos++; else break;
			}
			return Std.parseFloat(HxOverrides.substr(this.buf,p1,this.pos - p1));
		case 121:
			var len = this.readDigits();
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid string length";
			var s = HxOverrides.substr(this.buf,this.pos,len);
			this.pos += len;
			s = StringTools.urlDecode(s);
			this.scache.push(s);
			return s;
		case 107:
			return Math.NaN;
		case 109:
			return Math.NEGATIVE_INFINITY;
		case 112:
			return Math.POSITIVE_INFINITY;
		case 97:
			var buf = this.buf;
			var a = new Array();
			this.cache.push(a);
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c == 104) {
					this.pos++;
					break;
				}
				if(c == 117) {
					this.pos++;
					var n = this.readDigits();
					a[a.length + n - 1] = null;
				} else a.push(this.unserialize());
			}
			return a;
		case 111:
			var o = { };
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 114:
			var n = this.readDigits();
			if(n < 0 || n >= this.cache.length) throw "Invalid reference";
			return this.cache[n];
		case 82:
			var n = this.readDigits();
			if(n < 0 || n >= this.scache.length) throw "Invalid string reference";
			return this.scache[n];
		case 120:
			throw this.unserialize();
			break;
		case 99:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 119:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			var e = this.unserializeEnum(edecl,this.unserialize());
			this.cache.push(e);
			return e;
		case 106:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			this.pos++;
			var index = this.readDigits();
			var tag = Type.getEnumConstructs(edecl)[index];
			if(tag == null) throw "Unknown enum index " + name + "@" + index;
			var e = this.unserializeEnum(edecl,tag);
			this.cache.push(e);
			return e;
		case 108:
			var l = new List();
			this.cache.push(l);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) l.add(this.unserialize());
			this.pos++;
			return l;
		case 98:
			var h = new Hash();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 113:
			var h = new IntHash();
			this.cache.push(h);
			var buf = this.buf;
			var c = this.buf.charCodeAt(this.pos++);
			while(c == 58) {
				var i = this.readDigits();
				h.set(i,this.unserialize());
				c = this.buf.charCodeAt(this.pos++);
			}
			if(c != 104) throw "Invalid IntHash format";
			return h;
		case 118:
			var d = HxOverrides.strDate(HxOverrides.substr(this.buf,this.pos,19));
			this.cache.push(d);
			this.pos += 19;
			return d;
		case 115:
			var len = this.readDigits();
			var buf = this.buf;
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid bytes length";
			var codes = haxe.Unserializer.CODES;
			if(codes == null) {
				codes = haxe.Unserializer.initCodes();
				haxe.Unserializer.CODES = codes;
			}
			var i = this.pos;
			var rest = len & 3;
			var size = (len >> 2) * 3 + (rest >= 2?rest - 1:0);
			var max = i + (len - rest);
			var bytes = haxe.io.Bytes.alloc(size);
			var bpos = 0;
			while(i < max) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				var c3 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				var c4 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c3 << 6 | c4) & 255;
			}
			if(rest >= 2) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				if(rest == 3) {
					var c3 = codes[buf.charCodeAt(i++)];
					bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				}
			}
			this.pos += len;
			this.cache.push(bytes);
			return bytes;
		case 67:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			o.hxUnserialize(this);
			if(this.buf.charCodeAt(this.pos++) != 103) throw "Invalid custom data";
			return o;
		default:
		}
		this.pos--;
		throw "Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos;
	}
	,unserializeEnum: function(edecl,tag) {
		if(this.buf.charCodeAt(this.pos++) != 58) throw "Invalid enum format";
		var nargs = this.readDigits();
		if(nargs == 0) return Type.createEnum(edecl,tag);
		var args = new Array();
		while(nargs-- > 0) args.push(this.unserialize());
		return Type.createEnum(edecl,tag,args);
	}
	,unserializeObject: function(o) {
		while(true) {
			if(this.pos >= this.length) throw "Invalid object";
			if(this.buf.charCodeAt(this.pos) == 103) break;
			var k = this.unserialize();
			if(!js.Boot.__instanceof(k,String)) throw "Invalid object key";
			var v = this.unserialize();
			o[k] = v;
		}
		this.pos++;
	}
	,readDigits: function() {
		var k = 0;
		var s = false;
		var fpos = this.pos;
		while(true) {
			var c = this.buf.charCodeAt(this.pos);
			if(c != c) break;
			if(c == 45) {
				if(this.pos != fpos) break;
				s = true;
				this.pos++;
				continue;
			}
			if(c < 48 || c > 57) break;
			k = k * 10 + (c - 48);
			this.pos++;
		}
		if(s) k *= -1;
		return k;
	}
	,get: function(p) {
		return this.buf.charCodeAt(p);
	}
	,getResolver: function() {
		return this.resolver;
	}
	,setResolver: function(r) {
		if(r == null) this.resolver = { resolveClass : function(_) {
			return null;
		}, resolveEnum : function(_) {
			return null;
		}}; else this.resolver = r;
	}
	,resolver: null
	,scache: null
	,cache: null
	,length: null
	,pos: null
	,buf: null
	,__class__: haxe.Unserializer
}
var slplayer = {}
slplayer.core = {}
slplayer.core.Application = function(id,args) {
	this.dataObject = args;
	this.id = id;
	this.registeredComponents = new Array();
	this.nodeToCmpInstances = new Hash();
	this.metaParameters = new Hash();
};
$hxClasses["slplayer.core.Application"] = slplayer.core.Application;
$hxExpose(slplayer.core.Application, "playMachine");
slplayer.core.Application.__name__ = ["slplayer","core","Application"];
slplayer.core.Application.get = function(SLPId) {
	return slplayer.core.Application.instances.get(SLPId);
}
slplayer.core.Application.generateUniqueId = function() {
	return haxe.Md5.encode(HxOverrides.dateStr(new Date()) + Std.string(Std.random(new Date().getTime() | 0)));
}
slplayer.core.Application.init = function(appendTo,args) {
	var newId = slplayer.core.Application.generateUniqueId();
	var newInstance = new slplayer.core.Application(newId,args);
	slplayer.core.Application.instances.set(newId,newInstance);
	newInstance.launch(appendTo);
}
slplayer.core.Application.main = function() {
}
slplayer.core.Application.prototype = {
	getAssociatedComponents: function(node) {
		var nodeId = node.getAttribute("data-" + "slpid");
		if(nodeId != null) return this.nodeToCmpInstances.get(nodeId);
		return new List();
	}
	,addAssociatedComponent: function(node,cmp) {
		var nodeId = node.getAttribute("data-" + "slpid");
		var associatedCmps;
		if(nodeId != null) associatedCmps = this.nodeToCmpInstances.get(nodeId); else {
			nodeId = slplayer.core.Application.generateUniqueId();
			node.setAttribute("data-" + "slpid",nodeId);
			associatedCmps = new List();
		}
		associatedCmps.add(cmp);
		this.nodeToCmpInstances.set(nodeId,associatedCmps);
	}
	,callInitOnComponents: function() {
		var $it0 = this.nodeToCmpInstances.iterator();
		while( $it0.hasNext() ) {
			var l = $it0.next();
			var $it1 = l.iterator();
			while( $it1.hasNext() ) {
				var c = $it1.next();
				c.init();
			}
		}
	}
	,createComponentsOfType: function(componentClassName,args) {
		var componentClass = Type.resolveClass(componentClassName);
		if(componentClass == null) {
			var rslErrMsg = "ERROR cannot resolve " + componentClassName;
			throw rslErrMsg;
			return;
		}
		if(slplayer.ui.DisplayObject.isDisplayObject(componentClass)) {
			var classTag = slplayer.core.SLPlayerComponentTools.getUnconflictedClassTag(componentClassName,Lambda.map(this.registeredComponents,function(rc) {
				return rc.classname;
			}).iterator());
			var taggedNodes = new Array();
			var taggedNodesCollection = this.htmlRootElement.getElementsByClassName(classTag);
			var _g1 = 0, _g = taggedNodesCollection.length;
			while(_g1 < _g) {
				var nodeCnt = _g1++;
				taggedNodes.push(taggedNodesCollection[nodeCnt]);
			}
			if(componentClassName != classTag) {
				taggedNodesCollection = this.htmlRootElement.getElementsByClassName(componentClassName);
				var _g1 = 0, _g = taggedNodesCollection.length;
				while(_g1 < _g) {
					var nodeCnt = _g1++;
					taggedNodes.push(taggedNodesCollection[nodeCnt]);
				}
			}
			var _g = 0;
			while(_g < taggedNodes.length) {
				var node = taggedNodes[_g];
				++_g;
				var newDisplayObject;
				newDisplayObject = Type.createInstance(componentClass,[node,this.id]);
			}
		} else {
			var cmpInstance = null;
			if(args != null) cmpInstance = Type.createInstance(componentClass,[args]); else cmpInstance = Type.createInstance(componentClass,[]);
			if(cmpInstance != null && js.Boot.__instanceof(cmpInstance,slplayer.core.ISLPlayerComponent)) cmpInstance.initSLPlayerComponent(this.id);
		}
	}
	,initComponents: function() {
		var _g = 0, _g1 = this.registeredComponents;
		while(_g < _g1.length) {
			var rc = _g1[_g];
			++_g;
			this.createComponentsOfType(rc.classname,rc.args);
		}
		this.callInitOnComponents();
	}
	,registerComponent: function(componentClassName,args) {
		this.registeredComponents.push({ classname : componentClassName, args : args});
	}
	,registerComponentsforInit: function() {
		playmachine.ui.PlaylistPanel;
		this.registerComponent("playmachine.ui.PlaylistPanel");
		slplayer.ui.group.Group;
		this.registerComponent("slplayer.ui.group.Group");
		playmachine.audio.AudioManager;
		this.registerComponent("playmachine.audio.AudioManager");
		playmachine.audio.PlaylistManager;
		this.registerComponent("playmachine.audio.PlaylistManager");
	}
	,initMetaParameters: function() {
	}
	,initHtmlRootElementContent: function() {
		this.htmlRootElement.innerHTML = slplayer.core.Application._htmlBody;
	}
	,launch: function(appendTo) {
		if(appendTo != null) this.htmlRootElement = appendTo;
		if(this.htmlRootElement == null || this.htmlRootElement.nodeType != js.Lib.document.body.nodeType) this.htmlRootElement = js.Lib.document.body;
		if(this.htmlRootElement == null) {
			haxe.Log.trace("ERROR windows.document.body is null => You are trying to start your application while the document loading is probably not complete yet." + " To fix that, add the noAutoStart option to your slplayer application and control the application startup with: window.onload = function() { myApplication.init() };",{ fileName : "Application.hx", lineNumber : 135, className : "slplayer.core.Application", methodName : "launch"});
			return;
		}
		this.initHtmlRootElementContent();
		this.initMetaParameters();
		this.registerComponentsforInit();
		this.initComponents();
	}
	,getMetaParameter: function(metaParamKey) {
		return this.metaParameters.get(metaParamKey);
	}
	,metaParameters: null
	,registeredComponents: null
	,dataObject: null
	,htmlRootElement: null
	,nodeToCmpInstances: null
	,id: null
	,__class__: slplayer.core.Application
}
var application = {}
application.core = {}
application.core.Application = function(id,args) {
	slplayer.core.Application.call(this,id,args);
};
$hxClasses["application.core.Application"] = application.core.Application;
application.core.Application.__name__ = ["application","core","Application"];
application.core.Application.init = function(appendTo,args) {
	application.core.Logger.enable();
	var newId = slplayer.core.Application.generateUniqueId();
	var newInstance = new application.core.Application(newId,args);
	application.core.Application.instances.set(newId,newInstance);
	newInstance.launch(appendTo);
}
application.core.Application.main = function() {
}
application.core.Application.__super__ = slplayer.core.Application;
application.core.Application.prototype = $extend(slplayer.core.Application.prototype,{
	__class__: application.core.Application
});
slplayer.core.ISLPlayerComponent = function() { }
$hxClasses["slplayer.core.ISLPlayerComponent"] = slplayer.core.ISLPlayerComponent;
slplayer.core.ISLPlayerComponent.__name__ = ["slplayer","core","ISLPlayerComponent"];
slplayer.core.ISLPlayerComponent.prototype = {
	getSLPlayer: null
	,SLPlayerInstanceId: null
	,__class__: slplayer.core.ISLPlayerComponent
}
slplayer.ui = {}
slplayer.ui.IDisplayObject = function() { }
$hxClasses["slplayer.ui.IDisplayObject"] = slplayer.ui.IDisplayObject;
slplayer.ui.IDisplayObject.__name__ = ["slplayer","ui","IDisplayObject"];
slplayer.ui.IDisplayObject.__interfaces__ = [slplayer.core.ISLPlayerComponent];
slplayer.ui.IDisplayObject.prototype = {
	rootElement: null
	,__class__: slplayer.ui.IDisplayObject
}
slplayer.ui.DisplayObject = function(rootElement,SLPId) {
	this.rootElement = rootElement;
	slplayer.core.SLPlayerComponent.initSLPlayerComponent(this,SLPId);
	slplayer.core.Application.get(this.SLPlayerInstanceId).addAssociatedComponent(rootElement,this);
};
$hxClasses["slplayer.ui.DisplayObject"] = slplayer.ui.DisplayObject;
slplayer.ui.DisplayObject.__name__ = ["slplayer","ui","DisplayObject"];
slplayer.ui.DisplayObject.__interfaces__ = [slplayer.ui.IDisplayObject];
slplayer.ui.DisplayObject.isDisplayObject = function(cmpClass) {
	if(cmpClass == Type.resolveClass("slplayer.ui.DisplayObject")) return true;
	if(Type.getSuperClass(cmpClass) != null) return slplayer.ui.DisplayObject.isDisplayObject(Type.getSuperClass(cmpClass));
	return false;
}
slplayer.ui.DisplayObject.checkFilterOnElt = function(cmpClass,elt) {
	if(elt.nodeType != js.Lib.document.body.nodeType) throw "cannot instantiate " + Type.getClassName(cmpClass) + " on a non element node.";
	var tagFilter = haxe.rtti.Meta.getType(cmpClass) != null?haxe.rtti.Meta.getType(cmpClass).tagNameFilter:null;
	if(tagFilter == null) return;
	if(Lambda.exists(tagFilter,function(s) {
		return elt.nodeName.toLowerCase() == Std.string(s).toLowerCase();
	})) return;
	throw "cannot instantiate " + Type.getClassName(cmpClass) + " on this type of HTML element: " + elt.nodeName.toLowerCase();
}
slplayer.ui.DisplayObject.prototype = {
	init: function() {
	}
	,getSLPlayer: function() {
		return slplayer.core.SLPlayerComponent.getSLPlayer(this);
	}
	,rootElement: null
	,SLPlayerInstanceId: null
	,__class__: slplayer.ui.DisplayObject
}
slplayer.ui.group = {}
slplayer.ui.group.IGroupable = function() { }
$hxClasses["slplayer.ui.group.IGroupable"] = slplayer.ui.group.IGroupable;
slplayer.ui.group.IGroupable.__name__ = ["slplayer","ui","group","IGroupable"];
slplayer.ui.group.IGroupable.__interfaces__ = [slplayer.ui.IDisplayObject];
slplayer.ui.group.IGroupable.prototype = {
	groupElement: null
	,__class__: slplayer.ui.group.IGroupable
}
application.core.BaseComponent = function(rootElement,SLPid) {
	slplayer.ui.DisplayObject.call(this,rootElement,SLPid);
	slplayer.ui.group.Groupable.startGroupable(this);
	if(this.groupElement == null) this.groupElement = rootElement;
};
$hxClasses["application.core.BaseComponent"] = application.core.BaseComponent;
application.core.BaseComponent.__name__ = ["application","core","BaseComponent"];
application.core.BaseComponent.__interfaces__ = [slplayer.ui.group.IGroupable];
application.core.BaseComponent.__super__ = slplayer.ui.DisplayObject;
application.core.BaseComponent.prototype = $extend(slplayer.ui.DisplayObject.prototype,{
	_getData: function() {
		return application.core.Application.instances.get(this.SLPid).dataObject;
	}
	,initStyles: function() {
		if(!this.stylesAreInitiated) {
			this.stylesAreInitiated = true;
			var css = haxe.Resource.getString("styles");
			var style = js.Lib.document.createElement("style");
			var textNode = js.Lib.document.createTextNode(css);
			style.appendChild(textNode);
			this.groupElement.appendChild(style);
		}
	}
	,dispatchEventOnGroup: function(eventName,eventData) {
		application.helpers.HtmlDomHelper.dispatchCustomEvent(this.groupElement,eventName,eventData);
	}
	,getElementByName: function(name) {
		return application.helpers.HtmlDomHelper.getElementByClassName(this.rootElement,name);
	}
	,init: function() {
		this.initStyles();
	}
	,data: null
	,stylesAreInitiated: null
	,SLPid: null
	,groupElement: null
	,__class__: application.core.BaseComponent
	,__properties__: {get_data:"_getData"}
});
application.core.LoggerImpl = function(category,enabled) {
	if(enabled == null) enabled = false;
	this.category = category;
	this.enabled = enabled;
};
$hxClasses["application.core.LoggerImpl"] = application.core.LoggerImpl;
application.core.LoggerImpl.__name__ = ["application","core","LoggerImpl"];
application.core.LoggerImpl.prototype = {
	internalLog: function(method,msg) {
		if(!this.enabled) return;
		var cat = "[" + this.category + "]";
		if(window.console && console[method]) console[method](cat,msg); else application.core._Logger.LoggerGlobals.haxeTrace(cat + " " + Std.string(msg));
	}
	,error: function(msg) {
		this.internalLog("error",msg);
	}
	,trace: function(msg) {
		this.internalLog("log",msg);
	}
	,enable: function() {
		this.enabled = true;
	}
	,enabled: null
	,category: null
	,__class__: application.core.LoggerImpl
}
application.core.Logger = function() { }
$hxClasses["application.core.Logger"] = application.core.Logger;
application.core.Logger.__name__ = ["application","core","Logger"];
application.core.Logger.loggers = null;
application.core.Logger.getLogger = function(category) {
	if(application.core.Logger.loggers == null) application.core.Logger.loggers = new Hash();
	if(!application.core.Logger.loggers.exists(category)) application.core.Logger.loggers.set(category,new application.core.LoggerImpl(category));
	return application.core.Logger.loggers.get(category);
}
application.core.Logger.useCustomTrace = function() {
	haxe.Log.trace = application.core.Logger.trace;
}
application.core.Logger.enable = function() {
	application.core.Logger.useCustomTrace();
	application.core.Logger.logger.enable();
}
application.core.Logger.trace = function(msg,infos) {
	if(infos != null) msg = infos.fileName + ":" + infos.lineNumber + ": " + Std.string(msg) + " (" + infos.className + "." + infos.methodName + ")";
	application.core.Logger.logger.trace(msg);
}
application.core.Logger.error = function(msg) {
	application.core.Logger.logger.error(msg);
}
haxe.Log = function() { }
$hxClasses["haxe.Log"] = haxe.Log;
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
application.core._Logger = {}
application.core._Logger.LoggerGlobals = function() { }
$hxClasses["application.core._Logger.LoggerGlobals"] = application.core._Logger.LoggerGlobals;
application.core._Logger.LoggerGlobals.__name__ = ["application","core","_Logger","LoggerGlobals"];
application.helpers = {}
application.helpers.HtmlDomHelper = function() { }
$hxClasses["application.helpers.HtmlDomHelper"] = application.helpers.HtmlDomHelper;
application.helpers.HtmlDomHelper.__name__ = ["application","helpers","HtmlDomHelper"];
application.helpers.HtmlDomHelper.getElementByClassName = function(elt,name) {
	var a = elt.getElementsByClassName(name);
	return a[0];
}
application.helpers.HtmlDomHelper.dispatchCustomEvent = function(elt,eventName,data) {
	var e = js.Lib.document.createEvent("CustomEvent");
	e.initCustomEvent(eventName,false,false,data);
	elt.dispatchEvent(e);
}
application.helpers.HtmlDomHelper.getClassNames = function(elt) {
	var classes = elt.className;
	if(classes == null) return new Array();
	return classes.split(" ");
}
application.helpers.HtmlDomHelper.addClass = function(element,className) {
	if(element.className.indexOf(className) == -1) element.className += " " + className;
	return element;
}
application.helpers.HtmlDomHelper.removeClass = function(element,className) {
	if(element.className.indexOf(className) >= 0) {
		element.className = StringTools.replace(element.className,className,"");
		element.className = StringTools.trim(element.className);
	}
	return element;
}
application.helpers.HtmlDomHelper.toggleClass = function(element,className) {
	if(element.className.indexOf(className) == -1) return application.helpers.HtmlDomHelper.addClass(element,className); else return application.helpers.HtmlDomHelper.removeClass(element,className);
}
application.helpers.HtmlDomHelper.replaceClass = function(elt,currentClass,newClass) {
	application.helpers.HtmlDomHelper.removeClass(elt,currentClass);
	return application.helpers.HtmlDomHelper.addClass(elt,newClass);
}
application.helpers.HtmlDomHelper.getChildElements = function(elt) {
	var children = new List();
	var i;
	var _g1 = 0, _g = elt.childNodes.length;
	while(_g1 < _g) {
		var i1 = _g1++;
		var child = elt.childNodes[i1];
		if(child.nodeType == 1) children.add(child);
	}
	return children;
}
haxe.Json = function() {
};
$hxClasses["haxe.Json"] = haxe.Json;
haxe.Json.__name__ = ["haxe","Json"];
haxe.Json.parse = function(text) {
	return new haxe.Json().doParse(text);
}
haxe.Json.stringify = function(value) {
	return new haxe.Json().toString(value);
}
haxe.Json.prototype = {
	parseString: function() {
		var start = this.pos;
		var buf = new StringBuf();
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			if(c == 34) break;
			if(c == 92) {
				buf.b += HxOverrides.substr(this.str,start,this.pos - start - 1);
				c = this.str.charCodeAt(this.pos++);
				switch(c) {
				case 114:
					buf.b += String.fromCharCode(13);
					break;
				case 110:
					buf.b += String.fromCharCode(10);
					break;
				case 116:
					buf.b += String.fromCharCode(9);
					break;
				case 98:
					buf.b += String.fromCharCode(8);
					break;
				case 102:
					buf.b += String.fromCharCode(12);
					break;
				case 47:case 92:case 34:
					buf.b += String.fromCharCode(c);
					break;
				case 117:
					var uc = Std.parseInt("0x" + HxOverrides.substr(this.str,this.pos,4));
					this.pos += 4;
					buf.b += String.fromCharCode(uc);
					break;
				default:
					throw "Invalid escape sequence \\" + String.fromCharCode(c) + " at position " + (this.pos - 1);
				}
				start = this.pos;
			} else if(c != c) throw "Unclosed string";
		}
		buf.b += HxOverrides.substr(this.str,start,this.pos - start - 1);
		return buf.b;
	}
	,parseRec: function() {
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			switch(c) {
			case 32:case 13:case 10:case 9:
				break;
			case 123:
				var obj = { }, field = null, comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 125:
						if(field != null || comma == false) this.invalidChar();
						return obj;
					case 58:
						if(field == null) this.invalidChar();
						obj[field] = this.parseRec();
						field = null;
						comma = true;
						break;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					case 34:
						if(comma) this.invalidChar();
						field = this.parseString();
						break;
					default:
						this.invalidChar();
					}
				}
				break;
			case 91:
				var arr = [], comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 93:
						if(comma == false) this.invalidChar();
						return arr;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					default:
						if(comma) this.invalidChar();
						this.pos--;
						arr.push(this.parseRec());
						comma = true;
					}
				}
				break;
			case 116:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 114 || this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return true;
			case 102:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 97 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 115 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return false;
			case 110:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 108) {
					this.pos = save;
					this.invalidChar();
				}
				return null;
			case 34:
				return this.parseString();
			case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 45:
				this.pos--;
				if(!this.reg_float.match(HxOverrides.substr(this.str,this.pos,null))) throw "Invalid float at position " + this.pos;
				var v = this.reg_float.matched(0);
				this.pos += v.length;
				var f = Std.parseFloat(v);
				var i = f | 0;
				return i == f?i:f;
			default:
				this.invalidChar();
			}
		}
	}
	,nextChar: function() {
		return this.str.charCodeAt(this.pos++);
	}
	,invalidChar: function() {
		this.pos--;
		throw "Invalid char " + this.str.charCodeAt(this.pos) + " at position " + this.pos;
	}
	,doParse: function(str) {
		this.reg_float = new EReg("^-?(0|[1-9][0-9]*)(\\.[0-9]+)?([eE][+-]?[0-9]+)?","");
		this.str = str;
		this.pos = 0;
		return this.parseRec();
	}
	,quote: function(s) {
		this.buf.b += Std.string("\"");
		var i = 0;
		while(true) {
			var c = s.charCodeAt(i++);
			if(c != c) break;
			switch(c) {
			case 34:
				this.buf.b += Std.string("\\\"");
				break;
			case 92:
				this.buf.b += Std.string("\\\\");
				break;
			case 10:
				this.buf.b += Std.string("\\n");
				break;
			case 13:
				this.buf.b += Std.string("\\r");
				break;
			case 9:
				this.buf.b += Std.string("\\t");
				break;
			case 8:
				this.buf.b += Std.string("\\b");
				break;
			case 12:
				this.buf.b += Std.string("\\f");
				break;
			default:
				this.buf.b += String.fromCharCode(c);
			}
		}
		this.buf.b += Std.string("\"");
	}
	,toStringRec: function(v) {
		var $e = (Type["typeof"](v));
		switch( $e[1] ) {
		case 8:
			this.buf.b += Std.string("\"???\"");
			break;
		case 4:
			this.objString(v);
			break;
		case 1:
		case 2:
			this.buf.b += Std.string(v);
			break;
		case 5:
			this.buf.b += Std.string("\"<fun>\"");
			break;
		case 6:
			var c = $e[2];
			if(c == String) this.quote(v); else if(c == Array) {
				var v1 = v;
				this.buf.b += Std.string("[");
				var len = v1.length;
				if(len > 0) {
					this.toStringRec(v1[0]);
					var i = 1;
					while(i < len) {
						this.buf.b += Std.string(",");
						this.toStringRec(v1[i++]);
					}
				}
				this.buf.b += Std.string("]");
			} else if(c == Hash) {
				var v1 = v;
				var o = { };
				var $it0 = v1.keys();
				while( $it0.hasNext() ) {
					var k = $it0.next();
					o[k] = v1.get(k);
				}
				this.objString(o);
			} else this.objString(v);
			break;
		case 7:
			var e = $e[2];
			this.buf.b += Std.string(v[1]);
			break;
		case 3:
			this.buf.b += Std.string(v?"true":"false");
			break;
		case 0:
			this.buf.b += Std.string("null");
			break;
		}
	}
	,objString: function(v) {
		this.fieldsString(v,Reflect.fields(v));
	}
	,fieldsString: function(v,fields) {
		var first = true;
		this.buf.b += Std.string("{");
		var _g = 0;
		while(_g < fields.length) {
			var f = fields[_g];
			++_g;
			var value = Reflect.field(v,f);
			if(Reflect.isFunction(value)) continue;
			if(first) first = false; else this.buf.b += Std.string(",");
			this.quote(f);
			this.buf.b += Std.string(":");
			this.toStringRec(value);
		}
		this.buf.b += Std.string("}");
	}
	,toString: function(v) {
		this.buf = new StringBuf();
		this.toStringRec(v);
		return this.buf.b;
	}
	,reg_float: null
	,pos: null
	,str: null
	,buf: null
	,__class__: haxe.Json
}
haxe.Md5 = function() {
};
$hxClasses["haxe.Md5"] = haxe.Md5;
haxe.Md5.__name__ = ["haxe","Md5"];
haxe.Md5.encode = function(s) {
	return new haxe.Md5().doEncode(s);
}
haxe.Md5.prototype = {
	doEncode: function(str) {
		var x = this.str2blks(str);
		var a = 1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d = 271733878;
		var step;
		var i = 0;
		while(i < x.length) {
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			step = 0;
			a = this.ff(a,b,c,d,x[i],7,-680876936);
			d = this.ff(d,a,b,c,x[i + 1],12,-389564586);
			c = this.ff(c,d,a,b,x[i + 2],17,606105819);
			b = this.ff(b,c,d,a,x[i + 3],22,-1044525330);
			a = this.ff(a,b,c,d,x[i + 4],7,-176418897);
			d = this.ff(d,a,b,c,x[i + 5],12,1200080426);
			c = this.ff(c,d,a,b,x[i + 6],17,-1473231341);
			b = this.ff(b,c,d,a,x[i + 7],22,-45705983);
			a = this.ff(a,b,c,d,x[i + 8],7,1770035416);
			d = this.ff(d,a,b,c,x[i + 9],12,-1958414417);
			c = this.ff(c,d,a,b,x[i + 10],17,-42063);
			b = this.ff(b,c,d,a,x[i + 11],22,-1990404162);
			a = this.ff(a,b,c,d,x[i + 12],7,1804603682);
			d = this.ff(d,a,b,c,x[i + 13],12,-40341101);
			c = this.ff(c,d,a,b,x[i + 14],17,-1502002290);
			b = this.ff(b,c,d,a,x[i + 15],22,1236535329);
			a = this.gg(a,b,c,d,x[i + 1],5,-165796510);
			d = this.gg(d,a,b,c,x[i + 6],9,-1069501632);
			c = this.gg(c,d,a,b,x[i + 11],14,643717713);
			b = this.gg(b,c,d,a,x[i],20,-373897302);
			a = this.gg(a,b,c,d,x[i + 5],5,-701558691);
			d = this.gg(d,a,b,c,x[i + 10],9,38016083);
			c = this.gg(c,d,a,b,x[i + 15],14,-660478335);
			b = this.gg(b,c,d,a,x[i + 4],20,-405537848);
			a = this.gg(a,b,c,d,x[i + 9],5,568446438);
			d = this.gg(d,a,b,c,x[i + 14],9,-1019803690);
			c = this.gg(c,d,a,b,x[i + 3],14,-187363961);
			b = this.gg(b,c,d,a,x[i + 8],20,1163531501);
			a = this.gg(a,b,c,d,x[i + 13],5,-1444681467);
			d = this.gg(d,a,b,c,x[i + 2],9,-51403784);
			c = this.gg(c,d,a,b,x[i + 7],14,1735328473);
			b = this.gg(b,c,d,a,x[i + 12],20,-1926607734);
			a = this.hh(a,b,c,d,x[i + 5],4,-378558);
			d = this.hh(d,a,b,c,x[i + 8],11,-2022574463);
			c = this.hh(c,d,a,b,x[i + 11],16,1839030562);
			b = this.hh(b,c,d,a,x[i + 14],23,-35309556);
			a = this.hh(a,b,c,d,x[i + 1],4,-1530992060);
			d = this.hh(d,a,b,c,x[i + 4],11,1272893353);
			c = this.hh(c,d,a,b,x[i + 7],16,-155497632);
			b = this.hh(b,c,d,a,x[i + 10],23,-1094730640);
			a = this.hh(a,b,c,d,x[i + 13],4,681279174);
			d = this.hh(d,a,b,c,x[i],11,-358537222);
			c = this.hh(c,d,a,b,x[i + 3],16,-722521979);
			b = this.hh(b,c,d,a,x[i + 6],23,76029189);
			a = this.hh(a,b,c,d,x[i + 9],4,-640364487);
			d = this.hh(d,a,b,c,x[i + 12],11,-421815835);
			c = this.hh(c,d,a,b,x[i + 15],16,530742520);
			b = this.hh(b,c,d,a,x[i + 2],23,-995338651);
			a = this.ii(a,b,c,d,x[i],6,-198630844);
			d = this.ii(d,a,b,c,x[i + 7],10,1126891415);
			c = this.ii(c,d,a,b,x[i + 14],15,-1416354905);
			b = this.ii(b,c,d,a,x[i + 5],21,-57434055);
			a = this.ii(a,b,c,d,x[i + 12],6,1700485571);
			d = this.ii(d,a,b,c,x[i + 3],10,-1894986606);
			c = this.ii(c,d,a,b,x[i + 10],15,-1051523);
			b = this.ii(b,c,d,a,x[i + 1],21,-2054922799);
			a = this.ii(a,b,c,d,x[i + 8],6,1873313359);
			d = this.ii(d,a,b,c,x[i + 15],10,-30611744);
			c = this.ii(c,d,a,b,x[i + 6],15,-1560198380);
			b = this.ii(b,c,d,a,x[i + 13],21,1309151649);
			a = this.ii(a,b,c,d,x[i + 4],6,-145523070);
			d = this.ii(d,a,b,c,x[i + 11],10,-1120210379);
			c = this.ii(c,d,a,b,x[i + 2],15,718787259);
			b = this.ii(b,c,d,a,x[i + 9],21,-343485551);
			a = this.addme(a,olda);
			b = this.addme(b,oldb);
			c = this.addme(c,oldc);
			d = this.addme(d,oldd);
			i += 16;
		}
		return this.rhex(a) + this.rhex(b) + this.rhex(c) + this.rhex(d);
	}
	,ii: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitXOR(c,this.bitOR(b,~d)),a,b,x,s,t);
	}
	,hh: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitXOR(this.bitXOR(b,c),d),a,b,x,s,t);
	}
	,gg: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitOR(this.bitAND(b,d),this.bitAND(c,~d)),a,b,x,s,t);
	}
	,ff: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitOR(this.bitAND(b,c),this.bitAND(~b,d)),a,b,x,s,t);
	}
	,cmn: function(q,a,b,x,s,t) {
		return this.addme(this.rol(this.addme(this.addme(a,q),this.addme(x,t)),s),b);
	}
	,rol: function(num,cnt) {
		return num << cnt | num >>> 32 - cnt;
	}
	,str2blks: function(str) {
		var nblk = (str.length + 8 >> 6) + 1;
		var blks = new Array();
		var _g1 = 0, _g = nblk * 16;
		while(_g1 < _g) {
			var i = _g1++;
			blks[i] = 0;
		}
		var i = 0;
		while(i < str.length) {
			blks[i >> 2] |= HxOverrides.cca(str,i) << (str.length * 8 + i) % 4 * 8;
			i++;
		}
		blks[i >> 2] |= 128 << (str.length * 8 + i) % 4 * 8;
		var l = str.length * 8;
		var k = nblk * 16 - 2;
		blks[k] = l & 255;
		blks[k] |= (l >>> 8 & 255) << 8;
		blks[k] |= (l >>> 16 & 255) << 16;
		blks[k] |= (l >>> 24 & 255) << 24;
		return blks;
	}
	,rhex: function(num) {
		var str = "";
		var hex_chr = "0123456789abcdef";
		var _g = 0;
		while(_g < 4) {
			var j = _g++;
			str += hex_chr.charAt(num >> j * 8 + 4 & 15) + hex_chr.charAt(num >> j * 8 & 15);
		}
		return str;
	}
	,addme: function(x,y) {
		var lsw = (x & 65535) + (y & 65535);
		var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
		return msw << 16 | lsw & 65535;
	}
	,bitAND: function(a,b) {
		var lsb = a & 1 & (b & 1);
		var msb31 = a >>> 1 & b >>> 1;
		return msb31 << 1 | lsb;
	}
	,bitXOR: function(a,b) {
		var lsb = a & 1 ^ b & 1;
		var msb31 = a >>> 1 ^ b >>> 1;
		return msb31 << 1 | lsb;
	}
	,bitOR: function(a,b) {
		var lsb = a & 1 | b & 1;
		var msb31 = a >>> 1 | b >>> 1;
		return msb31 << 1 | lsb;
	}
	,__class__: haxe.Md5
}
haxe.Resource = function() { }
$hxClasses["haxe.Resource"] = haxe.Resource;
haxe.Resource.__name__ = ["haxe","Resource"];
haxe.Resource.content = null;
haxe.Resource.listNames = function() {
	var names = new Array();
	var _g = 0, _g1 = haxe.Resource.content;
	while(_g < _g1.length) {
		var x = _g1[_g];
		++_g;
		names.push(x.name);
	}
	return names;
}
haxe.Resource.getString = function(name) {
	var _g = 0, _g1 = haxe.Resource.content;
	while(_g < _g1.length) {
		var x = _g1[_g];
		++_g;
		if(x.name == name) {
			if(x.str != null) return x.str;
			var b = haxe.Unserializer.run(x.data);
			return b.toString();
		}
	}
	return null;
}
haxe.Resource.getBytes = function(name) {
	var _g = 0, _g1 = haxe.Resource.content;
	while(_g < _g1.length) {
		var x = _g1[_g];
		++_g;
		if(x.name == name) {
			if(x.str != null) return haxe.io.Bytes.ofString(x.str);
			return haxe.Unserializer.run(x.data);
		}
	}
	return null;
}
haxe._Template = {}
haxe._Template.TemplateExpr = $hxClasses["haxe._Template.TemplateExpr"] = { __ename__ : ["haxe","_Template","TemplateExpr"], __constructs__ : ["OpVar","OpExpr","OpIf","OpStr","OpBlock","OpForeach","OpMacro"] }
haxe._Template.TemplateExpr.OpVar = function(v) { var $x = ["OpVar",0,v]; $x.__enum__ = haxe._Template.TemplateExpr; $x.toString = $estr; return $x; }
haxe._Template.TemplateExpr.OpExpr = function(expr) { var $x = ["OpExpr",1,expr]; $x.__enum__ = haxe._Template.TemplateExpr; $x.toString = $estr; return $x; }
haxe._Template.TemplateExpr.OpIf = function(expr,eif,eelse) { var $x = ["OpIf",2,expr,eif,eelse]; $x.__enum__ = haxe._Template.TemplateExpr; $x.toString = $estr; return $x; }
haxe._Template.TemplateExpr.OpStr = function(str) { var $x = ["OpStr",3,str]; $x.__enum__ = haxe._Template.TemplateExpr; $x.toString = $estr; return $x; }
haxe._Template.TemplateExpr.OpBlock = function(l) { var $x = ["OpBlock",4,l]; $x.__enum__ = haxe._Template.TemplateExpr; $x.toString = $estr; return $x; }
haxe._Template.TemplateExpr.OpForeach = function(expr,loop) { var $x = ["OpForeach",5,expr,loop]; $x.__enum__ = haxe._Template.TemplateExpr; $x.toString = $estr; return $x; }
haxe._Template.TemplateExpr.OpMacro = function(name,params) { var $x = ["OpMacro",6,name,params]; $x.__enum__ = haxe._Template.TemplateExpr; $x.toString = $estr; return $x; }
haxe.Template = function(str) {
	var tokens = this.parseTokens(str);
	this.expr = this.parseBlock(tokens);
	if(!tokens.isEmpty()) throw "Unexpected '" + Std.string(tokens.first().s) + "'";
};
$hxClasses["haxe.Template"] = haxe.Template;
haxe.Template.__name__ = ["haxe","Template"];
haxe.Template.prototype = {
	run: function(e) {
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			this.buf.b += Std.string(Std.string(this.resolve(v)));
			break;
		case 1:
			var e1 = $e[2];
			this.buf.b += Std.string(Std.string(e1()));
			break;
		case 2:
			var eelse = $e[4], eif = $e[3], e1 = $e[2];
			var v = e1();
			if(v == null || v == false) {
				if(eelse != null) this.run(eelse);
			} else this.run(eif);
			break;
		case 3:
			var str = $e[2];
			this.buf.b += Std.string(str);
			break;
		case 4:
			var l = $e[2];
			var $it0 = l.iterator();
			while( $it0.hasNext() ) {
				var e1 = $it0.next();
				this.run(e1);
			}
			break;
		case 5:
			var loop = $e[3], e1 = $e[2];
			var v = e1();
			try {
				var x = $iterator(v)();
				if(x.hasNext == null) throw null;
				v = x;
			} catch( e2 ) {
				try {
					if(v.hasNext == null) throw null;
				} catch( e3 ) {
					throw "Cannot iter on " + Std.string(v);
				}
			}
			this.stack.push(this.context);
			var v1 = v;
			while( v1.hasNext() ) {
				var ctx = v1.next();
				this.context = ctx;
				this.run(loop);
			}
			this.context = this.stack.pop();
			break;
		case 6:
			var params = $e[3], m = $e[2];
			var v = Reflect.field(this.macros,m);
			var pl = new Array();
			var old = this.buf;
			pl.push($bind(this,this.resolve));
			var $it1 = params.iterator();
			while( $it1.hasNext() ) {
				var p = $it1.next();
				var $e = (p);
				switch( $e[1] ) {
				case 0:
					var v1 = $e[2];
					pl.push(this.resolve(v1));
					break;
				default:
					this.buf = new StringBuf();
					this.run(p);
					pl.push(this.buf.b);
				}
			}
			this.buf = old;
			try {
				this.buf.b += Std.string(Std.string(v.apply(this.macros,pl)));
			} catch( e1 ) {
				var plstr = (function($this) {
					var $r;
					try {
						$r = pl.join(",");
					} catch( e2 ) {
						$r = "???";
					}
					return $r;
				}(this));
				var msg = "Macro call " + m + "(" + plstr + ") failed (" + Std.string(e1) + ")";
				throw msg;
			}
			break;
		}
	}
	,makeExpr2: function(l) {
		var p = l.pop();
		if(p == null) throw "<eof>";
		if(p.s) return this.makeConst(p.p);
		switch(p.p) {
		case "(":
			var e1 = this.makeExpr(l);
			var p1 = l.pop();
			if(p1 == null || p1.s) throw p1.p;
			if(p1.p == ")") return e1;
			var e2 = this.makeExpr(l);
			var p2 = l.pop();
			if(p2 == null || p2.p != ")") throw p2.p;
			return (function($this) {
				var $r;
				switch(p1.p) {
				case "+":
					$r = function() {
						return e1() + e2();
					};
					break;
				case "-":
					$r = function() {
						return e1() - e2();
					};
					break;
				case "*":
					$r = function() {
						return e1() * e2();
					};
					break;
				case "/":
					$r = function() {
						return e1() / e2();
					};
					break;
				case ">":
					$r = function() {
						return e1() > e2();
					};
					break;
				case "<":
					$r = function() {
						return e1() < e2();
					};
					break;
				case ">=":
					$r = function() {
						return e1() >= e2();
					};
					break;
				case "<=":
					$r = function() {
						return e1() <= e2();
					};
					break;
				case "==":
					$r = function() {
						return e1() == e2();
					};
					break;
				case "!=":
					$r = function() {
						return e1() != e2();
					};
					break;
				case "&&":
					$r = function() {
						return e1() && e2();
					};
					break;
				case "||":
					$r = function() {
						return e1() || e2();
					};
					break;
				default:
					$r = (function($this) {
						var $r;
						throw "Unknown operation " + p1.p;
						return $r;
					}($this));
				}
				return $r;
			}(this));
		case "!":
			var e = this.makeExpr(l);
			return function() {
				var v = e();
				return v == null || v == false;
			};
		case "-":
			var e = this.makeExpr(l);
			return function() {
				return -e();
			};
		}
		throw p.p;
	}
	,makeExpr: function(l) {
		return this.makePath(this.makeExpr2(l),l);
	}
	,makePath: function(e,l) {
		var p = l.first();
		if(p == null || p.p != ".") return e;
		l.pop();
		var field = l.pop();
		if(field == null || !field.s) throw field.p;
		var f = field.p;
		haxe.Template.expr_trim.match(f);
		f = haxe.Template.expr_trim.matched(1);
		return this.makePath(function() {
			return Reflect.field(e(),f);
		},l);
	}
	,makeConst: function(v) {
		haxe.Template.expr_trim.match(v);
		v = haxe.Template.expr_trim.matched(1);
		if(HxOverrides.cca(v,0) == 34) {
			var str = HxOverrides.substr(v,1,v.length - 2);
			return function() {
				return str;
			};
		}
		if(haxe.Template.expr_int.match(v)) {
			var i = Std.parseInt(v);
			return function() {
				return i;
			};
		}
		if(haxe.Template.expr_float.match(v)) {
			var f = Std.parseFloat(v);
			return function() {
				return f;
			};
		}
		var me = this;
		return function() {
			return me.resolve(v);
		};
	}
	,parseExpr: function(data) {
		var l = new List();
		var expr = data;
		while(haxe.Template.expr_splitter.match(data)) {
			var p = haxe.Template.expr_splitter.matchedPos();
			var k = p.pos + p.len;
			if(p.pos != 0) l.add({ p : HxOverrides.substr(data,0,p.pos), s : true});
			var p1 = haxe.Template.expr_splitter.matched(0);
			l.add({ p : p1, s : p1.indexOf("\"") >= 0});
			data = haxe.Template.expr_splitter.matchedRight();
		}
		if(data.length != 0) l.add({ p : data, s : true});
		var e;
		try {
			e = this.makeExpr(l);
			if(!l.isEmpty()) throw l.first().p;
		} catch( s ) {
			if( js.Boot.__instanceof(s,String) ) {
				throw "Unexpected '" + s + "' in " + expr;
			} else throw(s);
		}
		return function() {
			try {
				return e();
			} catch( exc ) {
				throw "Error : " + Std.string(exc) + " in " + expr;
			}
		};
	}
	,parse: function(tokens) {
		var t = tokens.pop();
		var p = t.p;
		if(t.s) return haxe._Template.TemplateExpr.OpStr(p);
		if(t.l != null) {
			var pe = new List();
			var _g = 0, _g1 = t.l;
			while(_g < _g1.length) {
				var p1 = _g1[_g];
				++_g;
				pe.add(this.parseBlock(this.parseTokens(p1)));
			}
			return haxe._Template.TemplateExpr.OpMacro(p,pe);
		}
		if(HxOverrides.substr(p,0,3) == "if ") {
			p = HxOverrides.substr(p,3,p.length - 3);
			var e = this.parseExpr(p);
			var eif = this.parseBlock(tokens);
			var t1 = tokens.first();
			var eelse;
			if(t1 == null) throw "Unclosed 'if'";
			if(t1.p == "end") {
				tokens.pop();
				eelse = null;
			} else if(t1.p == "else") {
				tokens.pop();
				eelse = this.parseBlock(tokens);
				t1 = tokens.pop();
				if(t1 == null || t1.p != "end") throw "Unclosed 'else'";
			} else {
				t1.p = HxOverrides.substr(t1.p,4,t1.p.length - 4);
				eelse = this.parse(tokens);
			}
			return haxe._Template.TemplateExpr.OpIf(e,eif,eelse);
		}
		if(HxOverrides.substr(p,0,8) == "foreach ") {
			p = HxOverrides.substr(p,8,p.length - 8);
			var e = this.parseExpr(p);
			var efor = this.parseBlock(tokens);
			var t1 = tokens.pop();
			if(t1 == null || t1.p != "end") throw "Unclosed 'foreach'";
			return haxe._Template.TemplateExpr.OpForeach(e,efor);
		}
		if(haxe.Template.expr_splitter.match(p)) return haxe._Template.TemplateExpr.OpExpr(this.parseExpr(p));
		return haxe._Template.TemplateExpr.OpVar(p);
	}
	,parseBlock: function(tokens) {
		var l = new List();
		while(true) {
			var t = tokens.first();
			if(t == null) break;
			if(!t.s && (t.p == "end" || t.p == "else" || HxOverrides.substr(t.p,0,7) == "elseif ")) break;
			l.add(this.parse(tokens));
		}
		if(l.length == 1) return l.first();
		return haxe._Template.TemplateExpr.OpBlock(l);
	}
	,parseTokens: function(data) {
		var tokens = new List();
		while(haxe.Template.splitter.match(data)) {
			var p = haxe.Template.splitter.matchedPos();
			if(p.pos > 0) tokens.add({ p : HxOverrides.substr(data,0,p.pos), s : true, l : null});
			if(HxOverrides.cca(data,p.pos) == 58) {
				tokens.add({ p : HxOverrides.substr(data,p.pos + 2,p.len - 4), s : false, l : null});
				data = haxe.Template.splitter.matchedRight();
				continue;
			}
			var parp = p.pos + p.len;
			var npar = 1;
			while(npar > 0) {
				var c = HxOverrides.cca(data,parp);
				if(c == 40) npar++; else if(c == 41) npar--; else if(c == null) throw "Unclosed macro parenthesis";
				parp++;
			}
			var params = HxOverrides.substr(data,p.pos + p.len,parp - (p.pos + p.len) - 1).split(",");
			tokens.add({ p : haxe.Template.splitter.matched(2), s : false, l : params});
			data = HxOverrides.substr(data,parp,data.length - parp);
		}
		if(data.length > 0) tokens.add({ p : data, s : true, l : null});
		return tokens;
	}
	,resolve: function(v) {
		if(Reflect.hasField(this.context,v)) return Reflect.field(this.context,v);
		var $it0 = this.stack.iterator();
		while( $it0.hasNext() ) {
			var ctx = $it0.next();
			if(Reflect.hasField(ctx,v)) return Reflect.field(ctx,v);
		}
		if(v == "__current__") return this.context;
		return Reflect.field(haxe.Template.globals,v);
	}
	,execute: function(context,macros) {
		this.macros = macros == null?{ }:macros;
		this.context = context;
		this.stack = new List();
		this.buf = new StringBuf();
		this.run(this.expr);
		return this.buf.b;
	}
	,buf: null
	,stack: null
	,macros: null
	,context: null
	,expr: null
	,__class__: haxe.Template
}
haxe.io = {}
haxe.io.Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
$hxClasses["haxe.io.Bytes"] = haxe.io.Bytes;
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
}
haxe.io.Bytes.ofString = function(s) {
	var a = new Array();
	var _g1 = 0, _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		var c = s.charCodeAt(i);
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe.io.Bytes(a.length,a);
}
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
}
haxe.io.Bytes.prototype = {
	getData: function() {
		return this.b;
	}
	,toHex: function() {
		var s = new StringBuf();
		var chars = [];
		var str = "0123456789abcdef";
		var _g1 = 0, _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			chars.push(HxOverrides.cca(str,i));
		}
		var _g1 = 0, _g = this.length;
		while(_g1 < _g) {
			var i = _g1++;
			var c = this.b[i];
			s.b += String.fromCharCode(chars[c >> 4]);
			s.b += String.fromCharCode(chars[c & 15]);
		}
		return s.b;
	}
	,toString: function() {
		return this.readString(0,this.length);
	}
	,readString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c2 = b[i++];
				var c3 = b[i++];
				s += fcc((c & 15) << 18 | (c2 & 127) << 12 | c3 << 6 & 127 | b[i++] & 127);
			}
		}
		return s;
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len = this.length < other.length?this.length:other.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			if(b1[i] != b2[i]) return b1[i] - b2[i];
		}
		return this.length - other.length;
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		return new haxe.io.Bytes(len,this.b.slice(pos,pos + len));
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
		var b1 = this.b;
		var b2 = src.b;
		if(b1 == b2 && pos > srcpos) {
			var i = len;
			while(i > 0) {
				i--;
				b1[i + pos] = b2[i + srcpos];
			}
			return;
		}
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b1[i + pos] = b2[i + srcpos];
		}
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,get: function(pos) {
		return this.b[pos];
	}
	,b: null
	,length: null
	,__class__: haxe.io.Bytes
}
haxe.io.Error = $hxClasses["haxe.io.Error"] = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] }
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; }
haxe.rtti = {}
haxe.rtti.Meta = function() { }
$hxClasses["haxe.rtti.Meta"] = haxe.rtti.Meta;
haxe.rtti.Meta.__name__ = ["haxe","rtti","Meta"];
haxe.rtti.Meta.getType = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.obj == null?{ }:meta.obj;
}
haxe.rtti.Meta.getStatics = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.statics == null?{ }:meta.statics;
}
haxe.rtti.Meta.getFields = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.fields == null?{ }:meta.fields;
}
var js = {}
js.Boot = function() { }
$hxClasses["js.Boot"] = js.Boot;
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.isClass = function(o) {
	return o.__name__;
}
js.Boot.isEnum = function(e) {
	return e.__ename__;
}
js.Boot.getClass = function(o) {
	return o.__class__;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.Lib = function() { }
$hxClasses["js.Lib"] = js.Lib;
js.Lib.__name__ = ["js","Lib"];
js.Lib.document = null;
js.Lib.window = null;
js.Lib.debug = function() {
	debugger;
}
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib["eval"] = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
var playmachine = {}
playmachine.audio = {}
playmachine.audio.AudioManager = function(rootElement,SLPid) {
	application.core.BaseComponent.call(this,rootElement,SLPid);
};
$hxClasses["playmachine.audio.AudioManager"] = playmachine.audio.AudioManager;
playmachine.audio.AudioManager.__name__ = ["playmachine","audio","AudioManager"];
playmachine.audio.AudioManager.__super__ = application.core.BaseComponent;
playmachine.audio.AudioManager.prototype = $extend(application.core.BaseComponent.prototype,{
	onPlayRequest: function(e) {
		var t = e.detail;
		this.audio.setAttribute("src",t.file);
		this.audio.play();
	}
	,init: function() {
		application.core.BaseComponent.prototype.init.call(this);
		this.audio = application.helpers.HtmlDomHelper.getElementByClassName(this.rootElement,"audio");
		this.groupElement.addEventListener("playTrackRequest",$bind(this,this.onPlayRequest),false);
	}
	,audio: null
	,__class__: playmachine.audio.AudioManager
});
playmachine.audio.PlaylistManager = function(rootElement,SLPid) {
	application.core.BaseComponent.call(this,rootElement,SLPid);
};
$hxClasses["playmachine.audio.PlaylistManager"] = playmachine.audio.PlaylistManager;
playmachine.audio.PlaylistManager.__name__ = ["playmachine","audio","PlaylistManager"];
playmachine.audio.PlaylistManager.__super__ = application.core.BaseComponent;
playmachine.audio.PlaylistManager.prototype = $extend(application.core.BaseComponent.prototype,{
	__class__: playmachine.audio.PlaylistManager
});
playmachine.data = {}
playmachine.data.Track = function() { }
$hxClasses["playmachine.data.Track"] = playmachine.data.Track;
playmachine.data.Track.__name__ = ["playmachine","data","Track"];
playmachine.data.Track.prototype = {
	file: null
	,title: null
	,id: null
	,__class__: playmachine.data.Track
}
playmachine.event = {}
playmachine.event.Events = function() { }
$hxClasses["playmachine.event.Events"] = playmachine.event.Events;
playmachine.event.Events.__name__ = ["playmachine","event","Events"];
playmachine.event.HTML5AudioEvents = function() { }
$hxClasses["playmachine.event.HTML5AudioEvents"] = playmachine.event.HTML5AudioEvents;
playmachine.event.HTML5AudioEvents.__name__ = ["playmachine","event","HTML5AudioEvents"];
playmachine.ui = {}
playmachine.ui.PlaylistPanel = function(rootElement,SLPid) {
	application.core.BaseComponent.call(this,rootElement,SLPid);
};
$hxClasses["playmachine.ui.PlaylistPanel"] = playmachine.ui.PlaylistPanel;
playmachine.ui.PlaylistPanel.__name__ = ["playmachine","ui","PlaylistPanel"];
playmachine.ui.PlaylistPanel.__super__ = application.core.BaseComponent;
playmachine.ui.PlaylistPanel.prototype = $extend(application.core.BaseComponent.prototype,{
	addTrack: function(t) {
		var _g = this;
		var tpl = new haxe.Template(this.template);
		this.rootElement.innerHTML += tpl.execute({ title : t.title});
		var trackLine = js.Lib.document.getElementById("track" + t.id);
		var onTrackClick = function(e) {
			_g.dispatchEventOnGroup("playTrackRequest",t);
		};
		trackLine.addEventListener("click",onTrackClick,false);
	}
	,addTrackRequestHandler: function(e) {
		var t = e.detail;
		this.addTrack(t);
	}
	,init: function() {
		haxe.Log.trace("!!!",{ fileName : "PlaylistPanel.hx", lineNumber : 22, className : "playmachine.ui.PlaylistPanel", methodName : "init"});
		application.core.BaseComponent.prototype.init.call(this);
		this.template = this.rootElement.innerHTML;
		this.rootElement.innerHTML = "";
		this.rootElement.addEventListener("addTrackRequest",$bind(this,this.addTrackRequestHandler),false);
		haxe.Log.trace(haxe.Resource.getString("tracks"),{ fileName : "PlaylistPanel.hx", lineNumber : 32, className : "playmachine.ui.PlaylistPanel", methodName : "init"});
		haxe.Log.trace("????",{ fileName : "PlaylistPanel.hx", lineNumber : 33, className : "playmachine.ui.PlaylistPanel", methodName : "init"});
	}
	,template: null
	,__class__: playmachine.ui.PlaylistPanel
});
slplayer.core.SLPlayerComponent = function() { }
$hxClasses["slplayer.core.SLPlayerComponent"] = slplayer.core.SLPlayerComponent;
slplayer.core.SLPlayerComponent.__name__ = ["slplayer","core","SLPlayerComponent"];
slplayer.core.SLPlayerComponent.initSLPlayerComponent = function(component,SLPlayerInstanceId) {
	component.SLPlayerInstanceId = SLPlayerInstanceId;
}
slplayer.core.SLPlayerComponent.getSLPlayer = function(component) {
	return slplayer.core.Application.get(component.SLPlayerInstanceId);
}
slplayer.core.SLPlayerComponentTools = function() { }
$hxClasses["slplayer.core.SLPlayerComponentTools"] = slplayer.core.SLPlayerComponentTools;
slplayer.core.SLPlayerComponentTools.__name__ = ["slplayer","core","SLPlayerComponentTools"];
slplayer.core.SLPlayerComponentTools.checkRequiredParameters = function(cmpClass,elt) {
	var requires = haxe.rtti.Meta.getType(cmpClass).requires;
	if(requires == null) return;
	var _g = 0;
	while(_g < requires.length) {
		var r = requires[_g];
		++_g;
		if(elt.getAttribute(Std.string(r)) == null || StringTools.trim(elt.getAttribute(Std.string(r))) == "") throw Std.string(r) + " parameter is required for " + Type.getClassName(cmpClass);
	}
}
slplayer.core.SLPlayerComponentTools.getUnconflictedClassTag = function(displayObjectClassName,registeredComponentsClassNames) {
	var classTag = displayObjectClassName;
	if(classTag.indexOf(".") != -1) classTag = HxOverrides.substr(classTag,classTag.lastIndexOf(".") + 1,null);
	while(registeredComponentsClassNames.hasNext()) {
		var registeredComponentClassName = registeredComponentsClassNames.next();
		if(registeredComponentClassName != displayObjectClassName && classTag == HxOverrides.substr(registeredComponentClassName,classTag.lastIndexOf(".") + 1,null)) return displayObjectClassName;
	}
	return classTag;
}
slplayer.ui.group.Group = function(rootElement,SLPId) {
	slplayer.ui.DisplayObject.call(this,rootElement,SLPId);
};
$hxClasses["slplayer.ui.group.Group"] = slplayer.ui.group.Group;
slplayer.ui.group.Group.__name__ = ["slplayer","ui","group","Group"];
slplayer.ui.group.Group.__super__ = slplayer.ui.DisplayObject;
slplayer.ui.group.Group.prototype = $extend(slplayer.ui.DisplayObject.prototype,{
	__class__: slplayer.ui.group.Group
});
slplayer.ui.group.Groupable = function() { }
$hxClasses["slplayer.ui.group.Groupable"] = slplayer.ui.group.Groupable;
slplayer.ui.group.Groupable.__name__ = ["slplayer","ui","group","Groupable"];
slplayer.ui.group.Groupable.startGroupable = function(groupable) {
	var groupElements = groupable.getSLPlayer().htmlRootElement.getElementsByClassName(groupable.rootElement.getAttribute("data-group-id"));
	if(groupElements.length < 1) return;
	if(groupElements.length > 1) throw "ERROR " + groupElements.length + " Group components are declared with the same group id " + groupable.rootElement.getAttribute("data-group-id");
	groupable.groupElement = groupElements[0];
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
Array.prototype.__class__ = $hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
var Void = $hxClasses.Void = { __ename__ : ["Void"]};
haxe.Resource.content = [{ name : "tracks", data : "s823:WwogICAgewogICAgICAgIGlkIDogMSwKICAgICAgICB0aXRsZSA6ICJ0cmFjayAxIiwKICAgICAgICBmaWxlIDogImh0dHA6Ly93d3cudG9vbnpzaG9wLmNvbS9jb25mL3VwbG9hZC9zaG9wb25saW5lL3Byb2R1aXRzL0MvQ01SMDRfQ0QvY2hpbmVzZV9tYW5fMDZfY2hpbmVzZV9tYW5fbGVvX2xlX2J1Z19sZV95YW5fY2hpbmVzZV9tYW5fXzUubXAzIgogICAgfSwKICAgIHsKICAgICAgICBpZCA6IDIsCiAgICAgICAgdGl0bGUgOiAidHJhY2sgMiIsCiAgICAgICAgZmlsZSA6ICJodHRwOi8vd3d3LnRvb256c2hvcC5jb20vY29uZi91cGxvYWQvc2hvcG9ubGluZS9wcm9kdWl0cy9DL0NNUjA0X0NEL2NoaW5lc2VfbWFuXzA2X2NoaW5lc2VfbWFuX2xlb19sZV9idWdfbGVfeWFuX2NoaW5lc2VfbWFuX180Lm1wMyIKICAgIH0sCiAgICB7CiAgICAgICAgaWQgOiAzLAogICAgICAgIHRpdGxlIDogInRyYWNrIDMiLAogICAgICAgIGZpbGUgOiAiaHR0cDovL3d3dy50b29uenNob3AuY29tL2NvbmYvdXBsb2FkL3Nob3BvbmxpbmUvcHJvZHVpdHMvQy9DTVIwNF9DRC9jaGluZXNlX21hbl8wNl9jaGluZXNlX21hbl9sZW9fbGVfYnVnX2xlX3lhbl9jaGluZXNlX21hbl9fMy5tcDMiCiAgICB9Cl0"},{ name : "styles", data : "s8667:Ym9keSB7CiAgICBvdmVyZmxvdzogaGlkZGVuOwp9CgpodG1sLCBoZWFkLCBib2R5LCAucGxheU1hY2hpbmUgIHsKICAgIHdpZHRoOiAxMDAlOwogICAgaGVpZ2h0OiAxMDAlOwogICAgcGFkZGluZzogMDsKICAgIG1hcmdpbjogMDsKICAgIGNvbG9yOiNGRkZGRkY7CiAgICBmb250LWZhbWlseTogVHJlYnVjaGV0IE1TOwogICAgZm9udC1zaXplOjEzcHg7Cn0KCi5wbGF5TWFjaGluZSB7CiAgICB3aWR0aDogMTAwJTsKICAgIGhlaWdodDogYXV0byAhaW1wb3J0YW50OwogICAgbWluLWhlaWdodDogMTAwJTsKICAgIGJhY2tncm91bmQtY29sb3I6ICMwMDAwMDA7CiAgICBwb3NpdGlvbjpyZWxhdGl2ZTsKfQoKLmJ1dHRvbiB7CiAgICBiYWNrZ3JvdW5kLWltYWdlOiB1cmwoaW1hZ2VzL3Nwcml0ZXMucG5nKTsKICAgIGJhY2tncm91bmQtcmVwZWF0OiBub25lOwogICAgY3Vyc29yOiBwb2ludGVyOwp9CgouQXVkaW9NYW5hZ2VyIHsKICAgIGRpc3BsYXk6bm9uZTsKfQoKCgouSGVhZGVyIHsKICAgIGhlaWdodDozMHB4OwogICAgd2lkdGg6MTAwJTsKICAgIHBvc2l0aW9uOnJlbGF0aXZlOwp9Ci5IZWFkZXIgLmV4dHJhIHsKICAgIHBvc2l0aW9uOmFic29sdXRlOwogICAgdG9wOjA7CiAgICBsZWZ0OjA7CiAgICB3aWR0aDoxMDAlOwogICAgaGVpZ2h0OjI1cHg7CiAgICBiYWNrZ3JvdW5kLWltYWdlOiB1cmwoaW1hZ2VzL3Nwcml0ZXMucG5nKTsKICAgIGJhY2tncm91bmQtcmVwZWF0OiByZXBlYXQteDsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IDBweCAtMzIwcHg7Cn0KLkhlYWRlciAuTGFuZ1NlbGVjdG9yIHsKICAgIHBvc2l0aW9uOmFic29sdXRlOwogICAgdG9wOiA1cHg7CiAgICBsZWZ0OiA1cHg7CiAgICBoZWlnaHQ6IDE0cHg7CiAgICB3aWR0aDogMjNweDsKICAgIGJhY2tncm91bmQtaW1hZ2U6IHVybChpbWFnZXMvc3ByaXRlcy5wbmcpOwogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogMjA0cHggLTEyMHB4OwogICAgY3Vyc29yOiBwb2ludGVyOwp9CgouSGVhZGVyIC50aXRsZSB7CiAgICBwb3NpdGlvbjphYnNvbHV0ZTsKICAgIHRvcDo1cHg7CiAgICBsZWZ0OjM1cHg7CiAgICB3aWR0aDoxNjBweDsKICAgIGhlaWdodDogMjBweDsKICAgIGJhY2tncm91bmQtaW1hZ2U6IHVybChpbWFnZXMvc3ByaXRlcy5wbmcpOwogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogMHB4IC0zMDBweDsKfQouSGVhZGVyIC5saW5rIHsKICAgIHBvc2l0aW9uOmFic29sdXRlOwogICAgdG9wOjVweDsKICAgIHJpZ2h0OjEwcHg7Cn0KLkhlYWRlciAubGluayBhIHsKICAgIGNvbG9yOiNGRkZGRkY7CiAgICB0ZXh0LWRlY29yYXRpb246bm9uZTsKfQoKLkxlZnRDb2wgewogICAgcG9zaXRpb246IHJlbGF0aXZlOwp9CgouVHJhY2tJbWFnZSB7CiAgICBwb3NpdGlvbjphYnNvbHV0ZTsKICAgIHRvcDogMjVweDsKICAgIGxlZnQ6IDEwcHg7Cn0KCi5UcmFja0ltYWdlIGltZyB7CiAgICB3aWR0aDo5MnB4OwogICAgaGVpZ2h0OjkycHg7Cn0KCi5TaGFyZSB7CiAgICBtYXJnaW4tbGVmdDogMTBweDsKICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsKICAgIHdpZHRoOiA5MnB4Owp9CgouU2hhcmUgLmJ1dHRvbiB7CiAgICBwb3NpdGlvbjphYnNvbHV0ZTsKICAgIHdpZHRoOiAyMHB4OwogICAgaGVpZ2h0OiAyMHB4OwogICAgdG9wOjA7CiAgICByaWdodDowOwp9CgouU2hhcmUgLmZhY2Vib29rIHsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IC0xMDBweCAtMjIwcHg7CiAgICByaWdodDogMjJweDsKfQoKLlNoYXJlIC5lbWJlZCB7CiAgICBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAtODBweCAtMjIwcHg7Cn0KCi5Cb2R5IHsKICAgIGhlaWdodDoxMDAlOwogICAgd2lkdGg6MTAwJTsKICAgIG1hcmdpbi1ib3R0b206NTBweDsKfQouQm9keSAuTGVmdENvbCB7CiAgICB3aWR0aDoxMDBweDsKICAgIGZsb2F0OmxlZnQ7Cn0KLkJvZHkgLm1haW5Db2wgewogICAgaGVpZ2h0OjEwMCU7CiAgICBtYXJnaW4tbGVmdDoxMTBweDsKICAgIG1hcmdpbi1yaWdodDoxMHB4OwogICAgbWFyaWduLWJvdHRvbToxMHB4Owp9CgouVGFiQmFyIHsKICAgIGhlaWdodDogMjVweDsKfQoKLlRhYkJhciAuYmFyIHsKICAgIHBvc2l0aW9uOnJlbGF0aXZlOwp9CgouVGFiQmFyIC5idXR0b24gewogICAgd2lkdGg6MjVweDsKICAgIGhlaWdodDoyNXB4OwogICAgZmxvYXQ6IGxlZnQ7CiAgICBiYWNrZ3JvdW5kLXJlcGVhdDogbm9uZTsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IDBweCAtMTIwcHg7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNDM0NDQxOwogICAgY3Vyc29yOiBwb2ludGVyOwoKfQouVGFiQmFyIC5idXR0b24uYWN0aXZlIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICM5MDhCODY7Cn0KCi5UYWJCYXIgLmJ1dHRvbjpob3ZlciB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkZGRkZGOwp9CgouVGFiQmFyIC5jb21tZW50QnV0dG9uIHsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IC0yNXB4IC0xMjBweDsKfQoKLlRhYkJhciAuaW5mb0J1dHRvbiB7CiAgICBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAtNTBweCAtMTIwcHg7Cn0KCi5UYWJCYXIgLmNhcnRCdXR0b24gewogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogLTEyNXB4IC0xMjBweDsKfQoKLlRhYkJhciAubG9hZEJ1dHRvbiB7CiAgICBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAtMTAwcHggLTEyMHB4OwogICAgbWFyZ2luLWxlZnQ6IDEwcHg7Cn0KLlRhYkJhciAuc2F2ZUJ1dHRvbiB7CiAgICBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAtNzVweCAtMTIwcHg7Cn0KLlRhYkJhciAuZGVsZXRlQnV0dG9uIHsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IC0xNTBweCAtMTIwcHg7CiAgICBmbG9hdDogcmlnaHQ7Cn0KLlRhYkJhciAuY2xlYXJCdXR0b24gewogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogLTE3NXB4IC0xMjBweDsKICAgIGZsb2F0OiByaWdodDsKfQoKLlRhYkNvbnRhaW5lciB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjOTA4Qjg2OwogICAgaGVpZ2h0OiAxMDAlOwogICAgcG9zaXRpb246cmVsYXRpdmU7Cn0KCi5UYWJDb250YWluZXIgLnBhbmVsIHsKICAgIGRpc3BsYXk6bm9uZTsKfQoKLlRhYkNvbnRhaW5lciAucGFuZWwuYWN0aXZlIHsKICAgIGRpc3BsYXk6YmxvY2s7Cn0KCi5QbGF5bGlzdFBhbmVsIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICNDQ0NDQ0M7Cn0KCgouUGxheWxpc3RQYW5lbCAudHJhY2sgewogICAgYmFja2dyb3VuZC1jb2xvcjogI0U4RTNFNjsKICAgIG1pbi1oZWlnaHQ6MjBweDsKICAgIHBvc2l0aW9uOnJlbGF0aXZlO3MKfQoKLlBsYXlsaXN0UGFuZWwgLnRyYWNrLmFsdGVybmF0ZSB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjQ0FDN0M3Owp9CgouUGxheWxpc3RQYW5lbCAudHJhY2suY3VycmVudCB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkZDQzMzOwp9CgouUGxheWxpc3RQYW5lbCAudHJhY2s6aG92ZXIgewogICAgYmFja2dyb3VuZC1jb2xvcjojNjREMzAxOwp9CgouUGxheWxpc3RQYW5lbCAudHJhY2sgLnBsYXlpbmdJY28gewogICAgYmFja2dyb3VuZC1pbWFnZTogdXJsKGltYWdlcy9zcHJpdGVzLnBuZyk7CiAgICBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAtMTIwcHggLTIyMHB4OwogICAgd2lkdGg6MjBweDsKICAgIGhlaWdodDogMjBweDsKICAgIGZsb2F0OmxlZnQ7Cn0KCi5QbGF5bGlzdFBhbmVsIC50cmFjayAudGl0bGUgewogICAgbWFyZ2luLWxlZnQ6MjRweDsKICAgIG1hcmdpbi1yaWdodDoyNHB4OwogICAgZm9udC1zaXplOjExcHg7CiAgICBvdmVyZmxvdzphdXRvOwogICAgcGFkZGluZy10b3A6IDNweDsKICAgIGNvbG9yOiAjMDAwMDAwOwogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsKfQoKLlBsYXlsaXN0UGFuZWwgLnRyYWNrIC5yZW1vdmUgewogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogLTE0MHB4IC0yMjBweDsKICAgIHdpZHRoOjIwcHg7CiAgICBoZWlnaHQ6IDIwcHg7CiAgICBwb3NpdGlvbjphYnNvbHV0ZTsKICAgIHJpZ2h0OiAwOwogICAgdG9wOiAwOwp9Ci5QbGF5bGlzdFBhbmVsIC50cmFjayAucmVtb3ZlOmhvdmVyIHsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IC0xNDBweCAtMjQwcHg7Cn0KCi5Gb290ZXIgewogICAgcG9zaXRpb246YWJzb2x1dGU7CiAgICBib3R0b206MDsKICAgIGxlZnQ6MHB4OwogICAgaGVpZ2h0OjMwcHg7CiAgICB3aWR0aDoxMDAlOwoKCn0KCi5Gb290ZXIgLmV4dHJhIHsKICAgIHBvc2l0aW9uOmFic29sdXRlOwogICAgYm90dG9tOjA7CiAgICBsZWZ0OjA7CiAgICB3aWR0aDoxMDAlOwogICAgaGVpZ2h0OjI1cHg7CiAgICBiYWNrZ3JvdW5kLWltYWdlOiB1cmwoaW1hZ2VzL3Nwcml0ZXMucG5nKTsKICAgIGJhY2tncm91bmQtcmVwZWF0OiByZXBlYXQteDsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IDBweCAtMzQ1cHg7Cn0KCi5Db250cm9sQmFyIHsKICAgIGhlaWdodDo1MHB4OwogICAgbWFyZ2luLWxlZnQ6MTEwcHg7CiAgICBwb3NpdGlvbjogcmVsYXRpdmU7Cn0KCi5Db250cm9sQmFyIC5wcmV2aW91c0J1dHRvbiB7CiAgICBwb3NpdGlvbjphYnNvbHV0ZTsKICAgIGxlZnQ6MHB4OwogICAgdG9wOjBweDsKICAgIHdpZHRoOjIwcHg7CiAgICBoZWlnaHQ6MjBweDsKICAgIGJhY2tncm91bmQtaW1hZ2U6IHVybChpbWFnZXMvc3ByaXRlcy5wbmcpOwogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogMHB4IC0yMjBweDsKfQouQ29udHJvbEJhciAucHJldmlvdXNCdXR0b246aG92ZXIgewogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogMHB4IC0yNDBweDsKfQoKLkNvbnRyb2xCYXIgLnBsYXlQYXVzZUJ1dHRvbiB7CiAgICBwb3NpdGlvbjphYnNvbHV0ZTsKICAgIGxlZnQ6MzBweDsKICAgIHRvcDotNXB4OwogICAgd2lkdGg6MzBweDsKICAgIGhlaWdodDozMHB4OwogICAgYmFja2dyb3VuZC1pbWFnZTogdXJsKGltYWdlcy9zcHJpdGVzLnBuZyk7Cn0KCi5Db250cm9sQmFyIC5wbGF5UGF1c2VCdXR0b24ucGxheSB7CiAgICBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAwcHggMHB4Owp9Ci5Db250cm9sQmFyIC5wbGF5UGF1c2VCdXR0b24ucGxheTpob3ZlciB7CiAgICBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAwcHggLTMwcHg7Cn0KCi5Db250cm9sQmFyIC5wbGF5UGF1c2VCdXR0b24ucGF1c2UgewogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogLTMwcHggMHB4Owp9Ci5Db250cm9sQmFyIC5wbGF5UGF1c2VCdXR0b24ucGF1c2U6aG92ZXIgewogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogLTMwcHggLTMwcHg7Cn0KCi5Db250cm9sQmFyIC5mb3J3YXJkQnV0dG9uIHsKICAgIHBvc2l0aW9uOmFic29sdXRlOwogICAgbGVmdDo3MHB4OwogICAgdG9wOjBweDsKICAgIHdpZHRoOjIwcHg7CiAgICBoZWlnaHQ6MjBweDsKICAgIGJhY2tncm91bmQtaW1hZ2U6IHVybChpbWFnZXMvc3ByaXRlcy5wbmcpOwogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogLTIwcHggLTIyMHB4Owp9Ci5Db250cm9sQmFyIC5mb3J3YXJkQnV0dG9uOmhvdmVyIHsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IC0yMHB4IC0yNDBweDsKfQouQ29udHJvbEJhciAubXV0ZUJ1dHRvbiB7CiAgICBwb3NpdGlvbjphYnNvbHV0ZTsKICAgIHJpZ2h0OjY0cHg7CiAgICB0b3A6IDBweDsKICAgIHdpZHRoOiAyMHB4OwogICAgaGVpZ2h0OiAyMHB4OwogICAgYmFja2dyb3VuZC1wb3NpdGlvbjogLTQwcHggLTIyMHB4Owp9Ci5Db250cm9sQmFyIC5tdXRlQnV0dG9uOmhvdmVyIHsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IC00MHB4IC0yNDBweDsKfQouQ29udHJvbEJhciAuc291bmRMZXZlbCB7CiAgICBiYWNrZ3JvdW5kLWltYWdlOiB1cmwoaW1hZ2VzL3Nwcml0ZXMucG5nKTsKICAgIGJhY2tncm91bmQtcG9zaXRpb246IC0xNjBweCAtMjIwcHg7CiAgICB3aWR0aDogNDVweDsKICAgIGhlaWdodDogMTJweDsKICAgIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICAgIHJpZ2h0OiAxMnB4OwogICAgdG9wOiAzcHg7Cn0KLkNvbnRyb2xCYXIgLnNvdW5kTGV2ZWwgLmtub2IgewogICAgYmFja2dyb3VuZC1pbWFnZTogdXJsKGltYWdlcy9zcHJpdGVzLnBuZyk7CiAgICBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAtMjQwcHggLTIyMHB4OwogICAgaGVpZ2h0OiAxMnB4Owp9CgouRm9vdGVyIC5TZWVrQmFyIHsKICAgIG1hcmdpbi1yaWdodDogOTZweDsKICAgIG1hcmdpbi1sZWZ0OiAxMDRweDsKICAgIHBvc2l0aW9uOnJlbGF0aXZlOwp9CgouRm9vdGVyIC5TZWVrQmFyIC5wcm9ncmVzcyB7CiAgICBoZWlnaHQ6IDE1cHg7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjQ0NDQ0NDOwogICAgY3Vyc29yOiBwb2ludGVyOwp9CgouRm9vdGVyIC5TZWVrQmFyIC5wbGF5ZWQgewogICAgd2lkdGg6NTAlOwogICAgYmFja2dyb3VuZC1jb2xvcjogI0ZGQ0MzMzsKICAgIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICAgIGxlZnQ6IDBweDsKICAgIHRvcDogMDsKfQouRm9vdGVyIC5TZWVrQmFyIC5idWZmZXJlZCB7CiAgICB3aWR0aDoxMDAlOwp9CgoKLlJlbGVhc2VQYW5lbCwgLkNvbW1lbnRQYW5lbCwgLkNhcnRQYW5lbCB7CiAgICBkaXNwbGF5OiBub25lOwp9Cgo"}];
if(typeof document != "undefined") js.Lib.document = document;
if(typeof window != "undefined") {
	js.Lib.window = window;
	js.Lib.window.onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if(f == null) return false;
		return f(msg,[url + ":" + line]);
	};
}
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.CODES = null;
slplayer.core.Application.SLPID_ATTR_NAME = "slpid";
slplayer.core.Application.instances = new Hash();
slplayer.core.Application._htmlBody = haxe.Unserializer.run("y12230:%0A%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22Group1%20playMachine%20PlaylistManager%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22Cocktail%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22AudioManager%22%20data-group-id%3D%22Group1%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CAUDIO%20class%3D%22audio%22%3Enot%20supported%20%21%3C%2FAUDIO%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22Header%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22extra%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22LangSelector%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22title%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22link%22%3E%3CA%20href%3D%22http%3A%2F%2Fwww.toonzshop.com%22%20target%3D%22_blank%22%3Ewww.toonzshop.com%3C%2FA%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22Body%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22LeftCol%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22Share%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22shareTitle%22%3ESHARE%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22facebook%20button%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22embed%20button%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22TrackImage%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CIMG%20src%3D%22http%3A%2F%2Fstatic.toonzshop.com%2Fthumbnails%2Fconf%2Fupload%2Fshoponline%2Fproduits%2FI%2FINKALINK_17%2Finkalink-17.jpg-92x92-adaptative.jpg%22%2F%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22RateButton%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22CommentButton%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22TrackRate%22%3E%3C%2FDIV%3E%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22AddToCartButton%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22mainCol%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22TabComponent%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22TabBar%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22mainBar%20bar%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22playlistButton%20button%20playlist%20active%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22commentButton%20button%20release%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22infoButton%20button%20comment%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22cartButton%20button%20cart%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22secondaryBar%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22playlist%20bar%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22loadButton%20button%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22saveButton%20button%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22deleteButton%20button%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22clearButton%20button%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22TabContainer%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22PlaylistPanel%20playlist%20active%20panel%22%20data-group-id%3D%22Group1%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22track%22%20id%3D%22track%3A%3Aid%3A%3A%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22playingIco%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22title%22%3E%3A%3Atitle%3A%3A%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22remove%20button%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22TrackPanel%20release%20panel%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22title%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22info%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22artists%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22labels%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22style%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22description%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22CommentPanel%20comment%20panel%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22addCommentButton%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22nbComments%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22commentsContainer%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22CartPanel%20cart%20panel%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22itemContainer%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22totalContainer%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22total%22%3ETOTAL%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22price%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CSPAN%3E10%3C%2FSPAN%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22value%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22footer%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22addToPlaylistButton%22%3E%3A%3Atranslations.addPlaylistToCart%3A%3A%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22orderButton%22%3E%3A%3Atranslations.order%3A%3A%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22Footer%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22extra%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22ControlBar%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22previousButton%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22playPauseButton%20play%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22forwardButton%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22SeekBar%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22buffered%20progress%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22played%20progress%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CA%20href%3D%22%23%22%20class%3D%22knob%22%3E%3C%2FA%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22muteButton%20button%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22soundLevel%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3CDIV%20class%3D%22knob%22%3E%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20%20%20%20%20%3C%2FDIV%3E%0A%20%20%20%20");
application.core.Application.instances = new Hash();
application.core.Logger.logger = application.core.Logger.getLogger("Application");
application.core._Logger.LoggerGlobals.haxeTrace = haxe.Log.trace;
haxe.Template.splitter = new EReg("(::[A-Za-z0-9_ ()&|!+=/><*.\"-]+::|\\$\\$([A-Za-z0-9_-]+)\\()","");
haxe.Template.expr_splitter = new EReg("(\\(|\\)|[ \r\n\t]*\"[^\"]*\"[ \r\n\t]*|[!+=/><*.&|-]+)","");
haxe.Template.expr_trim = new EReg("^[ ]*([^ ]+)[ ]*$","");
haxe.Template.expr_int = new EReg("^[0-9]+$","");
haxe.Template.expr_float = new EReg("^([+-]?)(?=\\d|,\\d)\\d*(,\\d*)?([Ee]([+-]?\\d+))?$","");
haxe.Template.globals = { };
js.Lib.onerror = null;
playmachine.event.Events.NEXT_TRACK_REQUEST = "nextTrackRequest";
playmachine.event.Events.PREVIOUS_TRACK_REQUEST = "previousTrackRequest";
playmachine.event.Events.ADD_TRACK_REQUEST = "addTrackRequest";
playmachine.event.Events.PLAY_TRACK_REQUEST = "playTrackRequest";
playmachine.event.HTML5AudioEvents.AUDIO_LOADSTART = "loadstart";
playmachine.event.HTML5AudioEvents.AUDIO_PROGRESS = "progress";
playmachine.event.HTML5AudioEvents.AUDIO_SUSPEND = "suspend";
playmachine.event.HTML5AudioEvents.AUDIO_ABORT = "abort";
playmachine.event.HTML5AudioEvents.AUDIO_ERROR = "error";
playmachine.event.HTML5AudioEvents.AUDIO_EMPTIED = "emptied";
playmachine.event.HTML5AudioEvents.AUDIO_STALLED = "stalled";
playmachine.event.HTML5AudioEvents.AUDIO_PLAY = "play";
playmachine.event.HTML5AudioEvents.AUDIO_PAUSE = "pause";
playmachine.event.HTML5AudioEvents.AUDIO_LOADEDMETADATA = "loadedmetadata";
playmachine.event.HTML5AudioEvents.AUDIO_LOADEDDATA = "loadeddata";
playmachine.event.HTML5AudioEvents.AUDIO_WAITING = "waiting";
playmachine.event.HTML5AudioEvents.AUDIO_PLAYING = "playing";
playmachine.event.HTML5AudioEvents.AUDIO_CANPLAY = "canplay";
playmachine.event.HTML5AudioEvents.AUDIO_CANPLAYTHROUGH = "canplaythrough";
playmachine.event.HTML5AudioEvents.AUDIO_SEEKING = "seeking";
playmachine.event.HTML5AudioEvents.AUDIO_SEEKED = "seeked";
playmachine.event.HTML5AudioEvents.AUDIO_TIMEUPDATE = "timeupdate";
playmachine.event.HTML5AudioEvents.AUDIO_ENDED = "ended";
playmachine.event.HTML5AudioEvents.AUDIO_RATECHANGE = "ratechange";
playmachine.event.HTML5AudioEvents.AUDIO_DURATIONCHANGE = "durationchange";
playmachine.event.HTML5AudioEvents.AUDIO_VOLUMECHANGE = "volumechange";
slplayer.core.Application.main();
function $hxExpose(src, path) {
	var o = window;
	var parts = path.split(".");
	for(var ii = 0; ii < parts.length-1; ++ii) {
		var p = parts[ii];
		if(typeof o[p] == "undefined") o[p] = {};
		o = o[p];
	}
	o[parts[parts.length-1]] = src;
}
})();

//@ sourceMappingURL=playMachine.js.map