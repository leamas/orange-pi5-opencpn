TARGETS = power-btn power-led
SCRIPTS = opencpn-stop power-btn-poweroff
SERVICES = power-btn.service power-led.service
SERVICE_DIR ?= $(HOME)/.config/systemd/user

DESTDIR ?= $(HOME)/bin

CPPFLAGS =  -lwiringPi -I/usr/include

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

# Install as root.
install: all
	test -d $(DESTDIR) || mkdir $(DESTDIR)	
	install -m 755 $(TARGETS) $(SCRIPTS) $(DESTDIR)
	test -d $(SERVICE_DIR) || mkdir $(SERVICE_DIR)	
	install -m 644 $(SERVICES) $(SERVICE_DIR)

uninstall:
	for f in $(TARGETS) $(SCRIPTS); do rm -f $(DESTDIR)/$$f; done
	for f in $(SERVICES); do rm -f $(SERVICE_DIR)/$$f; done


install-user:
