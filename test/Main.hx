


class Main {
    static function main() {
        var a = p.MyEnum.A;
        trace('a: $a');

        a = 5;
        trace('a: $a');

        var b = p.MyEnum.fromString('B');
        trace('b: $b');
    }
}