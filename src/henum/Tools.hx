package henum;

import haxe.macro.Expr;
import haxe.macro.Context;
class Tools {
    static public function at(e:ExprDef)
		return {
			expr: e,
			pos: Context.currentPos()
		};

}
