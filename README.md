# Linux System Maintenance Automation using C++

## Overview
This project automates common Linux maintenance tasks like system information check, file backup, temporary junk cleaning and disk usage display.  
The complete menu based tool is developed in **C++20 using filesystem library**.  
This tool helps users reduce manual system maintenance efforts and automate repetitive daily operations.

This project was completed as part of **Linux OS & LSP Assignment** work.

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

## Day Wise Development Progress

| Day | Work Completed |
|-----|----------------|
| Day 1 | Implemented basic backup function in C++. Tested recursive file copy. Created logs and backup folder generation. |
| Day 2 | Added System Update concept (in bash version) and Cleanup part + System information function written in C++. |
| Day 3 | Combined modules into a single menu based C++ tool. Added interactive CLI. |
| Day 4 | Added logging function and removed unwanted directories from backup. Logging done in text file using ofstream. |
| Day 5 | Added auto cleanup (delete backup/logs older than 7 days). Performed bug fixing, removed unsupported folders, improved temp cleaning command. Final test run + report creation. |

The tool now does full automation cycle similar to a real Linux maintenance utility.

---

## How To Compile and Run

```bash
g++ -std=c++20 system_maintenance.cpp -o system_maintenance
./system_maintenance
