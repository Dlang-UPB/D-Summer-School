module is_expr_1;
import std.stdio;

void main(string[] args)
{
    static if (is (int))     // OK, int is a valid type
    {
        writeln("valid");
    } 

    static if(is (asd))      // if asd is not a user defined type, the check will fail
    {
        writeln("stop using such crippled names");
    }

}
