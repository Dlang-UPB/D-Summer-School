module def_templ;

import std.stdio;

T getResponse(T = int)(string question)
{
    writef("%s (%s): ", question, T.stringof);
    T response;
    readf(" %s", &response);

    return response;
}

int fib(int N)()
{
    if (N == 0)
        return 0;
    return N + fib!(N - 1)();
}

void main(string[] args)
{
    auto x = fib!(10)();
}
