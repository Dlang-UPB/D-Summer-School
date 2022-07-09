module template_specialisations;

import std.stdio : writeln;

void innerFun(T)(T data)
{
    writeln("innerFun");
    writeln(data + 5);
}

void privateFun(T)(T data)
{
    writeln("privateFun");
    innerFun(data);
}

void publicFun(T)(T data)
{
    writeln("publicFun");
    privateFun(data);
}

unittest
{
    publicFun(5);
    publicFun("D Summer School");
}
