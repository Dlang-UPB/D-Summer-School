auto gun()
{
    return "D " ~ "rules";
}

unittest
{
    auto x = gun();

    // check if the type of x is string
    assert(typeid(x) == typeid(string));
}
