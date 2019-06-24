import std.stdio;

void fun(int a)
{
    writeln("called: ", __PRETTY_FUNCTION__);
}

void main()
{
    import func;
    fun();
}
