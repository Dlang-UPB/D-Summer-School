DMD = dmd
DFLAGS = -unittest

all: $(BINARY)

$(BINARY): $(BINARY).d
	$(DMD) $(DFLAGS) $(BINARY).d

clean:
	rm -f $(BINARY) $(BINARY).o
