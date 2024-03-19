DESTDIR ?= /usr/local/bin

CPPFLAGS =  -lwiringPi -I/usr/include

all: power-btn power-led

clean:
	rm -f power-btn power-led

install: all
	install -m 755 power-btn power-led $(DESTDIR)

uninstall:
	rm -f $(DESTDIR)/power-led $(DESTDIR)/power-btn
