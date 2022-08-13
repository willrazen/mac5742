CC     = gcc-11
CFLAGS = -Wall -Wno-maybe-uninitialized -pedantic -g -O2
RM     = rm -rf
print  = echo

all: main

main: main.o matrix.o time_extra.o
	$(CC) $(CEXTRA) $(CFLAGS) -o $@ $^

.PHONY: test
test: test.o matrix.o time_extra.o
	$(CC) $(CEXTRA) $(CFLAGS) -o $@ $^
	./test

main.o: main.c time_extra.h matrix.h
	$(CC) $(CEXTRA) $(CFLAGS) -c $<

matrix.o: matrix.c matrix.h .FORCE
	$(CC) $(CEXTRA) $(CFLAGS) -c $< -o $@

time_extra.o: time_extra.c time_extra.h
	$(CC) $(CEXTRA) $(CFLAGS) -c $<

.PHONY: clean
clean:
	$(RM) *.o main test

.PHONY: .FORCE
.FORCE: