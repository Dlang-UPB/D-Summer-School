module templates_5;
import std.stdio;

class Stack(T)
{
private:
    T[] elements;
public:
    void push(T element)
    {
        elements ~= element;
    }
    void pop()
    {
        --elements.length;
    }
    T top()
    {
        return elements[$ - 1];
    }
    size_t length()
    {
        return elements.length;
    }
}

void main()
{
    auto stack = new Stack!double();
}
