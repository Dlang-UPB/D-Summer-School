void takePointer(int*) @safe {}
void takeRef(T)(ref T) @safe {}

void func(T)(T a)
{
    static if(is(T == int))
        takePointer(&a);
    else
        takeRef(a);
}

void main()
{
    func(2);
    func("asd");
}
