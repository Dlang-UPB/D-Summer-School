private struct Result
{
    int a;
    string b;
}

Result fun(int a, string b)
{
    Result res = Result(a, b);
    return res;
}

void main()
{
    Result k = fun(1, "foo");
}
