void main()
{
    int[] a;
    int[] b = [1, 2, 3];
    int[] c = [4, 5];

    a = b ~ c;       // a will be [1, 2, 3, 4, 5]
    a = b;           // a refers to b
    a = b ~ c[0..0]; // a refers to a copy of b
    a ~= c;          // equivalent to a = a ~ c;
}
