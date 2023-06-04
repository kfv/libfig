# Specify compilers and flags
CC       = clang
CFLAGS  += -Wall -Wextra -I./libfigpar -I./libfigput -fPIC
AR       = ar
ARFLAGS  = rcs
LDFLAGS += -L./target -lfigpar # required for string_m functions

# Specify the installation prefix
PREFIX = /usr/local

# List the source files, object files, and headers for each library
LIBFIGPAR_SRCS    = libfigpar/figpar.c libfigpar/string_m.c
LIBFIGPAR_OBJS    = $(LIBFIGPAR_SRCS:.c=.o)
LIBFIGPAR_HEADERS = libfigpar/figpar.h libfigpar/string_m.h

LIBFIGPUT_SRCS    = libfigput/figput.c
LIBFIGPUT_OBJS    = $(LIBFIGPUT_SRCS:.c=.o)
LIBFIGPUT_HEADERS = libfigput/figput.h

# Default target
all: target/libfigpar.a target/libfigpar.so target/libfigput.a target/libfigput.so

# Ensure target directory exists
target:
	mkdir -p target

# Build the libfigpar library
target/libfigpar.a: $(LIBFIGPAR_OBJS) | target
	$(AR) $(ARFLAGS) $@ $^

target/libfigpar.so: $(LIBFIGPAR_OBJS) | target
	$(CC) -shared -o $@ $^

# Build the libfigput library
target/libfigput.a: $(LIBFIGPUT_OBJS) target/libfigpar.so
	$(AR) $(ARFLAGS) $@ $(LIBFIGPUT_OBJS)

target/libfigput.so: $(LIBFIGPUT_OBJS) target/libfigpar.so
	$(CC) -shared -o $@ $(LIBFIGPUT_OBJS) $(LDFLAGS)

# Pattern rule for object files
.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

# Install the libraries, headers, and man pages
install: all install_figpar install_figput

install_figpar: target/libfigpar.a target/libfigpar.so
	install -m 0644 $(LIBFIGPAR_HEADERS) $(PREFIX)/include
	install -m 0755 target/libfigpar.a target/libfigpar.so $(PREFIX)/lib
	install -m 0644 libfigpar/figpar.3 $(PREFIX)/share/man/man3
	ln -sf $(PREFIX)/share/man/man3/figpar.3 $(PREFIX)/share/man/man3/get_config_option.3
	ln -sf $(PREFIX)/share/man/man3/figpar.3 $(PREFIX)/share/man/man3/parse_config.3
	ln -sf $(PREFIX)/share/man/man3/figpar.3 $(PREFIX)/share/man/man3/replaceall.3
	ln -sf $(PREFIX)/share/man/man3/figpar.3 $(PREFIX)/share/man/man3/strcount.3
	ln -sf $(PREFIX)/share/man/man3/figpar.3 $(PREFIX)/share/man/man3/strexpand.3
	ln -sf $(PREFIX)/share/man/man3/figpar.3 $(PREFIX)/share/man/man3/strexpandnl.3
	ln -sf $(PREFIX)/share/man/man3/figpar.3 $(PREFIX)/share/man/man3/strtolower.3

install_figput: target/libfigput.a target/libfigput.so
	install -m 0644 $(LIBFIGPUT_HEADERS) $(PREFIX)/include
	install -m 0755 target/libfigput.a target/libfigput.so $(PREFIX)/lib
	install -m 0644 libfigput/figput.3 $(PREFIX)/share/man/man3

# Uninstall the libraries, headers, and man pages
uninstall:
	cd $(PREFIX)/include && rm -f $(LIBFIGPAR_HEADERS) $(LIBFIGPUT_HEADERS)
	cd $(PREFIX)/lib && rm -f libfigpar.a libfigpar.so libfigput.a libfigput.so
	cd $(PREFIX)/share/man/man3 && rm -f figpar.3 get_config_option.3 parse_config.3 replaceall.3 strcount.3 strexpand.3 strexpandnl.3 strtolower.3 figput.3

# Clean up build products
clean:
	rm -rf target
	rm -f $(LIBFIGPAR_OBJS) $(LIBFIGPUT_OBJS)
