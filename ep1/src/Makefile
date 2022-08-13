CC=gcc-11
CC_OPT=-std=c11 -Wall -pedantic
CC_PTH=-pthread
CC_OMP=-fopenmp

OUTPUT=mandelbrot
IMAGE=.ppm

NUM_THREADS?=16
BENCH?=0

DEFS=-DNUM_THREADS=$(NUM_THREADS) -DBENCH=$(BENCH)

.PHONY: all
all: $(OUTPUT)_omp $(OUTPUT)_pth $(OUTPUT)_seq

$(OUTPUT)_omp: $(OUTPUT)_omp.c
	$(CC) $(DEFS) -o $(OUTPUT)_omp $(CC_OPT) $(CC_OMP) $(OUTPUT)_omp.c

$(OUTPUT)_pth: $(OUTPUT)_pth.c
	$(CC) $(DEFS) -o $(OUTPUT)_pth $(CC_OPT) $(CC_PTH) $(OUTPUT)_pth.c

$(OUTPUT)_seq: $(OUTPUT)_seq.c
	$(CC) $(DEFS) -o $(OUTPUT)_seq $(CC_OPT) $(OUTPUT)_seq.c

.PHONY: clean
clean:
	rm -f $(OUTPUT)_omp $(OUTPUT)_pth $(OUTPUT)_seq *$(IMAGE)
