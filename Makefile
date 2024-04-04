TARGETS = power-btn power-led
SCRIPTS = opencpn-stop
SERVICES = power-btn.service power-led.service

SERVICE_DIR ?= $(HOME)/.config/systemd/user
DESTDIR ?= $(HOME)/bin

CPPFLAGS =  -I/usr/include
LDLIBS = -lwiringPi

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

install: all
	test -d $(DESTDIR) || mkdir -p $(DESTDIR)
	install -m 755 $(TARGETS) $(SCRIPTS) $(DESTDIR)
	test -d $(SERVICE_DIR) || mkdir -p $(SERVICE_DIR)
	install -m 644 $(SERVICES) $(SERVICE_DIR)

uninstall:
	for f in $(TARGETS) $(SCRIPTS); do rm -f $(DESTDIR)/$$f; done
	for f in $(SERVICES); do rm -f $(SERVICE_DIR)/$$f; done
