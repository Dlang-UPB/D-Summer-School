---
title: Associative Arrays (AA)
parent: Introduction to D
nav_order: 5
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Associative Arrays (AA)

Associative arrays represent the D language hashtable implementation and have the following syntax:

```d
void main()
{
    // Associative array of ints that are indexed by string keys.
    // The KeyType is string.
    int[string] aa;

    // set value associated with key "hello" to 3
    aa["hello"] = 3;
    int value = aa["hello"];
}
```

## AA Operations

### Removing keys:

```d
void main()
{
    int[string] aa;
    aa["hello"] = 3;

    aa.remove("hello")     // removes the pair ("hello", 3)
}
```

`remove(key)` does nothing if the given key does not exist and returns `false`.
If the given key does exist, it removes it from the AA and returns `true`.
All keys can be removed by using the method `clear`.

### Testing membership:

```d
void main()
{
    int[string] aa;
    aa["hello"] = 3;

    int* p;
    p = "hello" in aa;

    if (p)
    {
        *p = 4;  // update value associated with key; aa["hello"] == 4
    }
}
```

The "in" expression yields a pointer to the value if the key is in the associative array, or `null` if not.

For more advanced operations on AAs check this [link](https://dlang.org/spec/hash-map.html#construction_assignment_entries).
For an exhaustive list of the AA properties check this [link](https://dlang.org/spec/hash-map.html#properties).

### Practice

1. Find the [majority element](https://leetcode.com/problems/majority-element/) in a string array using builtin associative arrays.
You can start your implementation using the skeleton inside `practice/majority-element` directory.

2. Go to this [link](https://github.com/TheAlgorithms/C/tree/master/searching).
You will find a series of searching algorithms, each implemented in C in its own file.
- Choose one algorithm and port it to D with minimum modifications.
- Update the code using D specific features to improve the code (fewer lines of code, increase in expressiveness etc.).

