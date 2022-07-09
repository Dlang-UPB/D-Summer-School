module cpp_class_interface.sol.main;

extern(C++, StackNamespace) {
    class Node {
    public:
        Node* next;
        Node* prev;
        char data;

        @disable this(char data);
    }

    class Stack {
    private:
        Node* topNode;
        int count;

    public:
        @disable this();
        @disable ~this();

        final bool empty();
        final int size();
        final char top();
        final void pop();
        final void push(scope char data);
    }

    Stack newStack();
    void deleteStack(ref Stack stack);
}

bool isValid(string s) {
    Stack stack = newStack();
    scope(exit) {
        deleteStack(stack);
    }
    
    for (int i = 0; i < s.length; ++i) {
        if (stack.empty()) {
            stack.push(s[i]);
        } else if ((stack.top() == '(' && s[i] == ')')
            || (stack.top() == '[' && s[i] == ']')
            || (stack.top() == '{' && s[i] == '}')) {
            stack.pop();
        } else {
            stack.push(s[i]);
        }
    }
    if (stack.empty()) {
        return true;
    }

    return false;
}

unittest {
    assert(isValid("[]"));
}

unittest {
    assert(isValid(""));
}

unittest {
    assert(!isValid("[]{]{}()"));
}

void main() {
}
