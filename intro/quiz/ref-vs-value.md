## Question Text

What is the output of the following program?

```d
void setLength(int[] a, size_t length)
{
    a.length = length;
}

void startWith2(int[] a)
{
    a[0] = 2;
    a[1] = 2;
}

void main()
{
    import std.stdio : writeln;
    int[] a = new int[5];
    
    a.setLength(2);
    a.startWith2();

    writeln(a);
}
```

## Question Answers

- [2, 2]
+ [2, 2, 0, 0, 0]
- [0, 0, 0, 0, 0]
- [0, 0]

## Feedback

Let's start with function `setLength`:
The trick here is that int[] a could be seen as a struct that is passed by value, hence modifying it will only reflect inside the function body.
If we wanted to modify the length of a we would have to add the `ref` keyword.
The second function `startWith2` does not change the variable `a`, only the data that `a` points to(heap values), hence these values will be changed.