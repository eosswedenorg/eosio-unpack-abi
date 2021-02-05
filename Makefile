
GO=go
OUTDIR=build

NAME     	?= eosio-unpack-abi
DESCRIPTION ?= Unpacks eosio's binary ABI to human readable JSON
VERSION  	?= 0.1
PREFIX   	?= /usr/local
BINDIR   	?= $(PREFIX)/bin
SHAREDIR   	?= $(PREFIX)/share/$(NAME)

.PHONY: build install deb clean

build :
	mkdir -p $(OUTDIR)
	$(GO) build -o $(OUTDIR) .

install : build
	install -t $(BINDIR) $(OUTDIR)/eosio-unpack-abi
	install -t $(SHAREDIR) LICENSE

deb : build
	export PACKAGE_NAME=$(NAME) \
	&& export PACKAGE_VERSION=$(VERSION) \
	&& export PACKAGE_DESCRIPTION="$(DESCRIPTION)" \
	&& export PACKAGE_BINDIR=$(BINDIR:/%=%) \
	&& export PACKAGE_SHAREDIR=$(SHAREDIR:/%=%) \
	&& export PACKAGE_BASE_DIR=$(OUTDIR) \
	&& /bin/bash scripts/build_deb.sh

clean :
	$(RM) -r $(OUTDIR)
