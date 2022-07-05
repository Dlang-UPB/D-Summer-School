module templates_3;
import std.stdio : writeln;

void printInParens(T)(T value, char opening, char closing)
{
    writeln(opening, value, closing);
}

void main()
{
    printInParens(42, '<', '>');
    //printInParens(42, '→', '←');
}
