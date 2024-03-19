#include <csignal>
#include <iostream>

#include <unistd.h>

#include "wiringPi.h"

const int LedPin = 2;  // Physical pin 7.


int main(int argc, char** argv) {
  wiringPiSetup();
  pinMode(LedPin, OUTPUT);
  digitalWrite(LedPin, HIGH);

  std::atexit([](){ digitalWrite(LedPin, LOW); });
  signal(SIGTERM, [](int){ digitalWrite(LedPin, LOW); });
  signal(SIGINT, [](int){ digitalWrite(LedPin, LOW); });

  while (true) sleep(2000);
}
