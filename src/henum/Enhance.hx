package henum;


import haxe.macro.Expr;
import haxe.macro.MacroStringTools;
import haxe.macro.TypeTools;
import haxe.macro.Context;

using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using StringTools;
using henum.Tools;
using Lambda;

class Enhance {
    @:using

	static public function build(parseDefault:String = null):Array<Field> {
        var localClass = Context.getLocalClass();
        var fields = Context.getBuildFields();
        var valuesNames = [];
        var name = localClass.get().name.replace("_Impl_", "");

		for (f in fields) {
			switch (f.kind) {
				case FVar(ct, e):
                    valuesNames.push(f.name);
				default:
			}
		}
        var unknownStr = EConst(CString('Invalid ${name}(')).at();
        var unknownExpr = macro $unknownStr + Std.string(this) + ")";

        var toStringSwitchExpr = ESwitch(EConst(CIdent("thisAsEnum")).at(), [
			for (v in valuesNames) {
				var c : Case =
				{
					values: [EConst(CIdent(v)).at()],
					expr: EConst(CString(v)).at()
				};
				c;
			}
		], unknownExpr).at();

        var enumType = TPath({
			name: name,
			pack: [],
		});

		var toString = {
			pos: Context.currentPos(),
			name: "toString",
			kind: FFun({args: [], ret: macro :String, expr: macro {var thisAsEnum : $enumType = cast this; return $toStringSwitchExpr;}}),
			meta: [],
			access: [APublic],
		};

        var unknownParseExpr = parseDefault != null ? EConst(CIdent(parseDefault)).at() : macro throw $unknownStr + s + ')';

        var parseSwitchExpr = ESwitch(EConst(CIdent("s")).at(), [
			for (v in valuesNames) {
				var c : Case =
				{
					values: [EConst(CString(v)).at()],
					expr: EConst(CIdent(v)).at()
				};
				c;
			}
		], unknownParseExpr).at();

        var fromString = {
            pos: Context.currentPos(),
            name: "fromString",
            kind: FFun({args: [{name: "s", type: macro :String}], ret: macro :$enumType, expr: macro return $parseSwitchExpr}),
            meta: [],
            access: [APublic, AStatic],
        };

        var printer = new haxe.macro.Printer();
        trace(printer.printField(fromString));

		return Context.getBuildFields().concat([toString, fromString]);
	}
}
