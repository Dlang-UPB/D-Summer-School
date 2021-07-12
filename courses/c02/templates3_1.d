import std.stdio;

// The function that already exists
void printInParens(T, ParT)(T value, ParT open, ParT close)
{
    writeln(open, value, close);
}

void main()
{
    MyStruct s;
    pragma(msg, MyStruct.stringof);
    writeln(s);
}
 
struct MyStruct
{
    int x;
    float y;
    //string toString() const
    //{
            //return "hello";
        //}
}
