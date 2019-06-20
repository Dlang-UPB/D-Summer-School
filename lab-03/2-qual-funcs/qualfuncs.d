struct A
{
    int a;

    void foo()
    {
        a = a + 2;
    }
}

void main()
{
    immutable A a;
    a.foo();
}
