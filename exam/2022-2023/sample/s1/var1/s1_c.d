string modifyString(string s)
{
    // TODO
}

unittest
{
    // The quick brown fox jumps over the lazy dog
    // After removing the words with length less than 4, the result is: "quick brown jumps over lazy"
    // After converting to uppercase, the result is: "QUCIK BROWN JUMPS OVER LAZY"
    // After sorting, the result is: "BROWN JUMPS LAZY OVER QUICK"
    // After joining, the result is: "BROWNJUMPSLAZYOVERQUICK"
    assert("BROWNJUMPSLAZYOVERQUICK" == fun("The quick brown fox jumps over the lazy dog"));
}
