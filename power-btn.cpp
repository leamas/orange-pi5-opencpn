#include <csignal>
#include <cstdlib>
#include <iostream>
#include <thread>

#include "wiringPi.h"

const int ButtonPin = 13;  // Physical pin 22.

int main(int argc, char** argv) {
  using namespace std::chrono_literals;

  wiringPiSetup();
  pinMode(ButtonPin, INPUT);
  while (true) {
    std::this_thread::sleep_for(300ms);
    int state = digitalRead(ButtonPin);
    if (state != 0) continue;

    std::this_thread::sleep_for(300ms);
    state = digitalRead(ButtonPin);
    if (state != 0) continue;

    std::cout << "Power button edge detected, going donw\n";
    // std::system("/usr/sbin/shutdown -h now");
  }
}
