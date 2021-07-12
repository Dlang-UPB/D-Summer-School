import std.stdio;

void main(string[] args)
{
    // is (/* ... */)
    // is ( expression )

    static if (is (int))     // passes
    {
        writeln("valid");
    } 

    static if(is (asd))      // if asd is not a user defined type, the check will fail
    {
        writeln("stop using such crippled names");
    }

    static if (1) {
        // is (T Alias)
        static if (is (int NewAlias))
        {
            writefln("NewAlias type is %s", NewAlias.stringof);
            NewAlias var = 42; // int and NewAlias are the same
        } 
        else
        {
            writeln("invalid");
        }
    }

}
