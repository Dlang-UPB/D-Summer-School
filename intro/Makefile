DMD = dmd
DFLAGS = -unittest -main

all: $(BINARY)

$(BINARY): $(BINARY).d
	$(DMD) $(DFLAGS) $(BINARY).d

clean:
	rm -f $(BINARY) $(BINARY).o

.PHONY: all clean