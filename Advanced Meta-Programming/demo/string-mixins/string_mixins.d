module string_mixins;

import std.stdio : writeln;
import std.conv : to;

enum sizes = ["Small", "Medium", "Large"];
enum lengths = [1, 64, 256];

static foreach (i, size; sizes)
    mixin("struct " ~ size ~ "Struct { int[" ~ lengths[i].to!string ~ "] x; }");

unittest
{
	// TODO: Update the sizes to fix these `assert`s.
    assert(SmallStruct.sizeof == 0);
    assert(MediumStruct.sizeof == 0);
    assert(LargeStruct.sizeof == 0);
}
