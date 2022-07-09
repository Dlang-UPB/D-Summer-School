#include <cstdlib>
#include <string>
#include <iostream>
#include <exception>

namespace StackNamespace {
  
class Node {
public:
    Node* next;
    Node* prev;
    char data;

    Node(char data) {
        this->data = data;
        this->prev = nullptr;
        this->next = nullptr;
    }
};

class Stack {
private:
    Node* topNode;
    int count;

public:
    Stack() {
        count = 0;
        topNode = nullptr;
    }

    ~Stack() {
        while(count) {
            pop();
        }
    }

    bool empty();
    int size();
    char top();
    void pop();
    void push(char data);
};

bool Stack::empty() {
    return count == 0;
}

int Stack::size() {
    return count;
}

char Stack::top() {
    try {
        return topNode->data;
    } catch (...) {
    }
}

void Stack::pop() {
    if (count == 0) return;
    Node* temp = topNode;
    if (count > 1) {
        topNode = topNode->prev;
        topNode->next = nullptr;
        temp->prev = nullptr;
    }

    free(temp);
    --count;
}

void Stack::push(char data) {
    Node* newNode = new Node(data);
    if (!empty()) {
        topNode->next = newNode;
        newNode->prev = topNode;
        topNode = newNode;
    } else {
        topNode = newNode;
    }
    ++count;
}

Stack* newStack() {
    return new Stack();
}

void deleteStack(Stack *&stack) {
    delete stack;
    stack = 0;
}
}
