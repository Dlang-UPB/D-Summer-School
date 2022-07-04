import std.conv : to;

class BigClass
{
    /* this sequence is used to generate at compile
       time the following code:

       int a0;
       int a1;
       ...
       int a999;
    */
    static foreach(i; 0 .. 1000)
        mixin("int a" ~ to!string(i) ~ ";");
}

int var;

void get_a0(BigClass a)
{
    var = a.a0;
    a.a0 = 42;
}

void main()
{
    import std.stdio : writeln;

    BigClass s = new BigClass();
    for (int i = 0; i < 1_000_000; i++)
        get_a0(s);

    writeln(s.a0);
}

