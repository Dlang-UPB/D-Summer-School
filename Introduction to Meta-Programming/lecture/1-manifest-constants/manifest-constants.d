module manifest_constants;
import std.stdio;

void main(string[] args)
{
    int a = 5;
    enum i = 4;      // i is 4 of type int
    enum long l = 3; // l is 3 of type long
    enum b = 5 + 2;   // ok, '5' and '2' are integer literals, known at compile time
    enum c = a + 2;   // error: 'a' cannot be read at compile time  
}
