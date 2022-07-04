void main()
{
    // Associative array of ints that are indexed by string keys.
    // The KeyType is string.
    int[string] aa;

    // set value associated with key "hello" to 3
    aa["hello"] = 3;
    int value = aa["hello"];

    int* p = "hello" in aa;
    if (p)
    {
        *p = 4; // update value associated with key; aa["hello"] == 4
    }

    aa.remove("hello");
}
