class Stack(T)
{
private:
    T[] elements;
public:
    void push(T element)
    {
        elements ~= element;
    }
    auto pop()
    {
        auto r = top();
        --elements.length;
        return r;
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
