module template_constraints_1;
import std.stdio;

struct A
{
    int doSomething() { return 42; }
}

void fun(T)(T a)
{
    a.doSomething();
}

void main()
{
    A a;
    int b;

    fun(a);
    fun(b);
}

