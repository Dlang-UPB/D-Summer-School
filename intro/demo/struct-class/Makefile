DC = dmd

all: struct class

struct:
	$(DC) struct.d

class:
	$(DC) class.d

clean:
	rm -f class.o struct.o class struct

.PHONY: all clean