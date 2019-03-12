RM = rm -rf
CWD ?= $(shell pwd)
KCC ?= konanc
KLIB ?= klib
MKDIR = mkdir -p
INSTALL ?= install

OS ?= $(shell uname)
TEST ?= test/
NAME ?= sodium
PREFIX ?= /usr/local

build: klib
klib: sodium.klib
static: lib/libsodium.a

install: build
	$(KLIB) install $(KOTLIN_LIBRARY)

uninstall:
	$(KLIB) remove $(NAME)

clean:
	$(RM) sodium-build/ sodium.klib META-INF lib tmp libsodium.a include
	$(MAKE) clean -C examples
	if test -f libsodium/Makefile; then $(MAKE) clean -C libsodium; fi
	rm -f sodium.def

sodium.klib: sodium.def lib/libsodium.a
	cinterop -pkg datkt.sodium -def sodium.def -o sodium

sodium.def: sodium.def.in
	./configure

lib/libsodium.a: libsodium
	./configure
	$(MAKE) -C libsodium
	$(MAKE) install -C libsodium

libsodium:
	git submodule update --recursive --init
