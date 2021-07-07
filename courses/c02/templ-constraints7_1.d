module templ_constraints;

struct A
{
    int doSomething() { return 42; }
}

void fun(T)(T a)
if (is ( typeof(a.doSomething) ))

{
    a.doSomething();    // <--- error here
}

void main()
{
    A a;
    int b;
    fun(a);
    fun(b);
}
