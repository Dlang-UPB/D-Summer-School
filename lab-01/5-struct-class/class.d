import std.conv : to;

class BigClass
{
    static foreach(i; 0 .. 1000)
        mixin("int a" ~ to!string(i) ~ ";");
}

int var;

void get_a0(BigClass a)
{
    var = a.a0;
}

void main()
{
    BigClass s = new BigClass();
    for(int i = 0; i < 100000; i++)
        get_a0(s);
}
