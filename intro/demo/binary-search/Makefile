DC = dmd
DFLAGS = -unittest

all: binarySearch

binarySearch: binarySearch.d
	$(DC) $(DFLAGS) binarySearch.d

clean:
	rm -f binarySearch.o binarySearch

.PHONY: all clean