# Linux System Maintenance Automation using C++

## Overview
This project automates common Linux maintenance tasks like system information check, file backup, temporary junk cleaning and disk usage display.  
The complete menu based tool is developed in **C++20 using filesystem library**.  
This tool helps users reduce manual system maintenance effort and automate repetitive daily operations.

> NOTE: There is also another version of this same project implemented in Bash Shell Script (for those who do not want to use C++). That version was done as Day 1–5 development in scripting approach before converting into C++ program.

---

## Features Implemented

| Feature | Description |
|--------|-------------|
| System Info | Shows CPU model, Memory usage and System uptime |
| Backup Function | Creates automatic backup folder with timestamp |
| Clean Temp Files | Removes temporary files owned by current user from /tmp |
| Disk Usage Display | Shows total disk usage summary |
| Auto Cleanup | Removes old backup and log files older than 7 days |

---

## Technology Used
- C++20
- g++ compiler
- Linux operating system
- std::filesystem
- std::chrono
- Shell commands integration using `system()` call

---

## Algorithm Summary
1. Launch program shows menu based interface.
2. On each selection, specific function runs such as backup / cleanup / info / disk usage.
3. Backup is done using `filesystem::copy` recursive copying.
4. Program auto-creates backup + logs folder if they don’t exist.
5. After backup or cleaning, program calls auto-cleaner to delete files older than 7 days.
6. Logging is maintained in `/logs/` folder for all tasks.

---

## Day Wise Development Progress (Student Level)

| Day | Work Completed |
|-----|----------------|
| Day 1 | Backup automation idea implemented first in bash. Tested recursive copy. |
| Day 2 | Added System Update + Cleanup concept in bash version + started C++ conversion. |
| Day 3 | Combined modules in C++ menu based program. |
| Day 4 | Added logging and removed unwanted folders (snap, system folders) from backup. |
| Day 5 | Added auto cleanup of old logs/backups and final testing + documentation. |

So basically first we built bash script version and tested logic.  
Then we converted final stable version into C++ program.

---

## How To Compile and Run (C++ Version)

```bash
g++ -std=c++20 system_maintenance.cpp -o system_maintenance
./system_maintenance
