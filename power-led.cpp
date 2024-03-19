#include <csignal>
#include <iostream>
#include <thread>

#include "wiringPi.h"

const int LedPin = 2;  // Physical pin 7.

int main(int argc, char** argv) {
  using namespace std::chrono_literals;

  wiringPiSetup();
  pinMode(LedPin, OUTPUT);
  digitalWrite(LedPin, HIGH);

  std::atexit([](){ digitalWrite(LedPin, LOW); });
  std::signal(SIGTERM, [](int){ digitalWrite(LedPin, LOW); exit(0); });
  std::signal(SIGINT, [](int){ digitalWrite(LedPin, LOW); exit(0);  });

  while (true) std::this_thread::sleep_for(2000s);
}
