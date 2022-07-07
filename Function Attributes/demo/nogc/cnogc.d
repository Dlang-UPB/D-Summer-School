// Hints: manual memory allocation, template attributes inference

class C
{
    int a;
    int b;
}

void main(string[] args)
{
    C c = new C;

    int[] myDynamicArray = [1, 2, 3];

    // Although this works, we want to keep myDynamicArray as a slice.
    int[3] myStaticArray = [1, 2, 3];
}
