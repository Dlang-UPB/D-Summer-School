
main: main.d stack.o
	dmd $^ -L-lstdc++ -unittest

stack.o: stack.cpp
	g++ -c $^

run:
	./main

clean:
	rm *.o main
