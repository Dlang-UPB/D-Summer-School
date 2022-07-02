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
        import std.stdio : writeln;
        bool found;

        for (int i = 0; i < entries.length; i++)
        {
            if (entries[i].key == key)
            {
                entries[i].val = val;
                found = true;
            }
        }

        if (!found)
        {
            Entry e = {key, val};
            entries ~= e;
        }
    }

    // create a new(different) associative array, that has the same entries
    MyAssociativeArray clone()
    {
        MyAssociativeArray newAA;

        foreach (entry; this.entries)
        {
            newAA.add(entry.key, entry.val);
        }

        return newAA;
    }

    // return a vector with all keys
    string[] keys()
    {
        string[] ret;

        foreach (entry; this.entries)
        {
            ret ~= entry.key;
        }

        return ret;
    }

    // return a vector with all values
    int[] values()
    {
        int[] ret;

        foreach (entry; this.entries)
        {
            ret ~= entry.val;
        }

        return ret;
    }

    // delete an entry
    void remove(string key)
    {
        for (int i = 0; i < entries.length; i++)
        {
            if (entries[i].key == key)
                entries = entries[0 .. i] ~ entries[i + 1 .. $];
        }
    }

    // return the value for entry `key`.
    // if key does not exist in the associative array, return 0
    int get(string key)
    {
        foreach (entry; entries)
        {
            if (entry.key == key)
                return entry.val;
        }

        return 0;
    }

    // returns how many entries are in the associative array
    ulong size()
    {
        return entries.length;
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