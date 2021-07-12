module explicit_templ;

import std.stdio;

T getResponse(T)(string question)
{
    pragma(msg, T.stringof);
    writef("%s (%s): ", question, T.stringof);
    T response;
    readf(" %s", &response);

    return response;
}

void main(string[] args)
{
    auto response = getResponse!int("What is your age?");
    writefln("User input was %s", response);
}
