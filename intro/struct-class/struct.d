import std.conv : to;

struct BigStruct
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

void get_a0(BigStruct a)
{
    var = a.a0;
    a.a0 = 42;
}

void main()
{
    BigStruct s;
    for(int i = 0; i < 1000000; i++)
        get_a0(s);
}
