DMD = dmd
DFLAGS = -unittest -main

all: $(BINARY) $(BINARY_WITH_MAIN)

$(BINARY): $(BINARY).d
	$(DMD) $(DFLAGS) $(BINARY).d

$(BINARY_WITH_MAIN): $(BINARY_WITH_MAIN).d
	$(DMD) $(BINARY_WITH_MAIN).d

clean:
	rm -f $(BINARY) $(BINARY_WITH_MAIN) *.o

.PHONY: all clean

