module templates_4;
import std.stdio;

T getResponse(T)(string question)
{
    writef("%s (%s): ", question, T.stringof);
    T response;
    readf(" %s", &response);

    return response;
}

void main(string[] args)
{
    int age = getResponse("What is your age?");

    writefln("You are %s years old", age);
}
