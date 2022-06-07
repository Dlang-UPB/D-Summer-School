int binarySearch(int[] arr, int l, int r, int x)
{
    if (r > l)
    {
        int mid = l + (r - l) / 2;

        if (arr[mid] == x)
            return mid;

        if (arr[mid] > x)
            return binarySearch(arr, l, mid - 1, x);

        return binarySearch(arr, mid + 1, r, x); 
    }

    return -1;
}

void main()
{
    import std.stdio : writeln;

    int[] arr = [1, 2, 4, 5, 7, 9];
    auto pos = arr.binarySearch(0, cast(int)arr.length, 2);
    writeln(pos);
}
