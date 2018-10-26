RM := rm -f
KCC ?= konanc
SRC := $(wildcard *.kt)
KEXES := $(patsubst %.kt,%.kexe,$(SRC))
TARGETS := $(patsubst %.kt,%,$(SRC))

build: all
all: $(TARGETS)

%: %.kexe
	./$^

%.kexe: %.kt
	$(KCC) util.kt $^ -l ../sodium.klib -o $@

clean:
	$(RM) $(KEXES)
