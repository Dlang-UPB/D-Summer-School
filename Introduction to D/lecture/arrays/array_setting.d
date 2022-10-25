void main()
{
    int[3] a = [1, 2, 3];
    //int[3] c = [ 1, 2, 3, 4];  // error: mismatched sizes
    int[] b = [1, 2, 3, 4, 5];
    a = 3;                     // set all elements of a to 3
    a[] = 2;                   // same as `a = 3`; using an empty slice is the same as slicing the full array
    b = a[0 .. $];             // $ evaluates to the length of the array (in this case 3)
    b = a[];                   // semantically equivalent to the one above
    b = a[0 .. a.length];      // semantically equivalent to the one above
    b[] = a[];                 // semantically equivalent to the one above
    b[2 .. 4] = 4;             // same as b[2] = 4, b[3] = 4
    b[0 .. 4] = a[0 .. 4];     // error, a does not have 4 elements
    a[0 .. 3] = b[];           // error, operands have different length
}
