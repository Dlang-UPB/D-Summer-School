DMD = dmd
DFLAGS = -unittest

all: logger

logger: logger.d
	$(DMD) $(DFLAGS) logger.d

clean:
	rm -f logger logger.o
