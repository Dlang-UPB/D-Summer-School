// One easy way to instantiate a struct is Entry e = {key, val};
struct Entry
{
    string key;
    int val;
}

struct MyAssociativeArray
{
    Entry[] entries;

    // add (key, val) entry in our associative array
    void add(string key, int val)
    {
        
    }

    // create a new(different) associative array, that has the same entries
    MyAssociativeArray clone()
    {
        MyAssociativeArray myNewAA;
        return myNewAA;
    }

    // return a vector with all keys
    string[] keys()
    {
        return null;
    }

    // return a vector with all values
    int[] values()
    {
        return null;
    }

    // delete an entry
    void remove(string key)
    {

    }

    // return the value for entry `key`.
    // if key does not exist in the associative array, return 0
    int get(string key)
    {
        return 0;
    }

    // returns how many entries are in the associative array
    ulong size()
    {
        return 0;
    }
}

unittest
{
    import std.algorithm : sort;
    import std.stdio : writeln;

    MyAssociativeArray aa;

    assert(aa.size() == 0);
    aa.add("hello", 2);
    assert(aa.get("hello") == 2);
    aa.add("hello", 3);
    assert(aa.get("hello") == 3);
    aa.add("D", 7);
    assert(aa.size() == 2);
    aa.remove("D");
    assert(aa.size() == 1);
    assert(aa.get("D") == 0);

    MyAssociativeArray otherAa = aa.clone();
    assert(otherAa.get("hello") == 3);
    otherAa.add("D", 9);
    assert(otherAa.get("D") == 9);
    assert(aa.get("D") == 0);
    otherAa.add("Dss", 10);
    assert(otherAa.keys().sort() == ["hello", "D", "Dss"].sort());
    writeln("Congratulations, all tests passed!");
}

