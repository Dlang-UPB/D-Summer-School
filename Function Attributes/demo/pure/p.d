import std;

struct S
{
 	int a;   
}

void mutate (ref S s, int[] b)
{
 	s.a = 44;
    b[] = 77;
}

void main()
{
	auto x = S(10);
    int[] b = new int[10];
    b[] = 3;
    mutate(x, b);
    writeln(x);
    writeln(b);
}