import std.random : rndGen;
import std.range : take;
import std.algorithm : filter, equal;

void main()
{
    enum words = ["You", "will", "pioneer", "the", "first", "Martian", "colony"]; 
    enum expected = ["pioneer", "Martian", "colony"];

    auto res = words.filter!(a => a.length == 6 || a.length == 7);

    assert(equal(res, expected));
}
