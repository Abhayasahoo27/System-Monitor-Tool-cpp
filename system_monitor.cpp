#include <iostream>
#include <fstream>
#include <string>
#include <unistd.h>

using namespace std;

// Function to get memory info
void getMemoryUsage() {
    ifstream meminfo("/proc/meminfo");
    string label;
    long memTotal, memFree;
    while (meminfo >> label) {
        if (label == "MemTotal:") meminfo >> memTotal;
        else if (label == "MemFree:") meminfo >> memFree;
    }
    cout << "Memory Usage: " << (memTotal - memFree) / 1024 << " MB used of " << memTotal / 1024 << " MB" << endl;
}

// Function to get CPU info
void getCPUInfo() {
    ifstream cpuinfo("/proc/stat");
    string cpu;
    long user, nice, system, idle;
    cpuinfo >> cpu >> user >> nice >> system >> idle;
    long total = user + nice + system + idle;
    double usage = (double)(total - idle) / total * 100.0;
    cout << "CPU Usage (approx): " << usage << "%" << endl;
}

int main() {
    cout << "=== System Monitor Tool (Day 1) ===" << endl;
    getCPUInfo();
    getMemoryUsage();
    return 0;
}
