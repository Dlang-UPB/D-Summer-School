
main: main.d sum_members.o
	dmd $^

maind: main.d
	dmd $^ -o $@

mainc: main
	gcc $^ -o mainc

sum_members.o: sum_members.c
	gcc -c $^ -o $@

run:
	./main

rund:
	./maind

runc:
	./mainc

clean:
	rm *.o main
