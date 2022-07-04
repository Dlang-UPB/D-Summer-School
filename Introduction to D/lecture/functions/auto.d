auto fun()
{
    return 7;
}

void main()
{
    int b = fun();
    auto c = fun();   // works for variables also
}
