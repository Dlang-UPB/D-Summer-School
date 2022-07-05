module is_expr_2;
import std.stdio;

void main(string[] args)
{
    static if (is (int NewAlias))
    {
        writeln("valid");
        NewAlias var = 42; // int and NewAlias are the same
    } 
    else
    {
        writeln("invalid");
    }
}
