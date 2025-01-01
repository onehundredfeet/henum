# henum
Tiny repository of improvements for the haxe enum abstract (Int)


# Usage
Just add the build macro to an abstract int enum.  You can specify the default value as a parameter if you want parsing to not throw on invalid values.

```haxe
@:build(henum.Enhance.build("A"))
enum abstract MyEnum (Int ) from Int{
    var A;
    var B;
    var C;
}
```

This adds toString and fromString to the abstract.

```haxe
var a = p.MyEnum.A;
trace('a: $a'); // results in a: A
var b = p.MyEnum.fromString('B');
trace('b: $b'); // results in b: B
```


