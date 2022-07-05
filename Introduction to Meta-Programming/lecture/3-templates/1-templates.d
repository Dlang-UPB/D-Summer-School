module templates_1;
import std.stdio;

// The function that already exists
void printInParens(int value)
{
    writefln("(%s)", value);
}

// Overloading the function for 'double'
void printInParens(double value)
{
    writefln("(%f)", value);
}

void main(string[] args)
{
    printInParens(42);
    printInParens(42.0);
}
