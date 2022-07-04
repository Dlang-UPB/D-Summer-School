void main()
{
    int[10] a;       // declare array of 10 ints
    int[] b;

    b = a[1..3];     // a[1..3] is a 2 element array consisting of a[1] and a[2]
    int x = b[1];    // equivalent to `int x = 0;`
    a[2] = 3;
    int y = b[1];    // equivalent to `int y = 3;`
}
