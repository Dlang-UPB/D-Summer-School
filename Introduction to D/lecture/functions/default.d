void fun(int a, int b=8, int c) {}

void main()
{
    fun(7);    // calls fun(7, 8)
    fun(2, 3); // calls fun(2, 3)
}
