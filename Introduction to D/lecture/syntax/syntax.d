int main()
{
    int position = 7, c, n = 10;
    int[10] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    //for (c = position - 1; c < n - 1; c++)
        //array[c] = array[c+1];


    int[] b =  array[0 .. position] ~ array[position + 1 .. $];

    import std.stdio;
    printf("Resultant array:\n");
    writeln(b);
    return 0;
}
