struct LinkedListNode(T)
{
    T elem;
    T* next;

    // allocate a new node
    static LinkedListNode* create(T elem)
    {
        auto node = new LinkedListNode();
        node.elem = elem;
        return node;
    }
}

struct LinkedList(T)
{
    LinkedListNode!T start;
}
