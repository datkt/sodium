CD = cd
CP = cp -rf
RM = rm -rf
MV = mv -f
CWD ?= $(shell pwd)
KCC ?= konanc
KLIB ?= klib
MKDIR = mkdir -p
INSTALL ?= install

OS ?= $(shell uname)
TEST ?= test/
NAME ?= sodium
BUILD ?= $(CWD)/build
PREFIX ?= /usr/local

build: klib
klib: sodium.klib
static: libsodium.a

install: build
	$(KLIB) install $(KOTLIN_LIBRARY)

uninstall:
	$(KLIB) remove $(NAME)

clean:
	$(RM) $(BUILD) $(CLASSES) sodium-build/ sodium.klib META-INF lib tmp libsodium.a
	$(MAKE) clean -C examples
	if test -f libsodium/Makefile; then $(MAKE) clean -C libsodium; fi

sodium.klib: sodium.def libsodium.a
	cinterop -def sodium.def -o sodium

libsodium.a: libsodium
	./configure
	$(MAKE) -C libsodium
	$(CP) libsodium/src/libsodium/.libs/libsodium.a .

libsodium:
	git submodule update --recursive --init
