RM := rm -f
KCC ?= konanc
SRC := $(wildcard *.kt)
KEXES := $(patsubst %.kt,%.kexe,$(SRC))
TARGETS := $(patsubst %.kt,%,$(SRC))

random: random.kexe

%.kexe: %.kt
	$(KCC) util.kt $^ -l ../sodium.klib -o $@
	./$@

clean:
	$(RM) $(KEXES)
