#include <iostream>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <chrono>
#include <ctime>
#include <vector>
#include <algorithm>

namespace fs = std::filesystem;

void logAction(const std::string &message) {
    fs::create_directories("logs");
    std::ofstream logFile("logs/system_log.txt", std::ios::app);
    if (logFile.is_open()) {
        auto now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
        logFile << "[" << std::ctime(&now) << "] " << message << "\n";
        logFile.close();
    }
}

void cleanOldLogs() {
    std::string logDir = "logs";
    auto now = std::chrono::system_clock::now();

    for (const auto &entry : fs::directory_iterator(logDir)) {
        auto ftime = fs::last_write_time(entry);
        auto sctp = std::chrono::time_point_cast<std::chrono::system_clock::duration>(
            ftime - fs::file_time_type::clock::now() + std::chrono::system_clock::now()
        );
        auto age = now - sctp;
        auto days_old = std::chrono::duration_cast<std::chrono::hours>(age).count() / 24;
        if (days_old > 7) {
            fs::remove(entry.path());
        }
    }
}

void cleanOldBackups() {
    std::string backupDir = "backup";
    if(!fs::exists(backupDir)) return;

    auto now = std::chrono::system_clock::now();

    for (const auto &entry : fs::directory_iterator(backupDir)) {
        auto ftime = fs::last_write_time(entry);
        auto sctp = std::chrono::time_point_cast<std::chrono::system_clock::duration>(
            ftime - fs::file_time_type::clock::now() + std::chrono::system_clock::now()
        );
        auto age = now - sctp;
        auto days_old = std::chrono::duration_cast<std::chrono::hours>(age).count() / 24;
        if (days_old > 7) {
            fs::remove_all(entry.path());
        }
    }
}

void showSystemInfo() {
    std::cout << "\n===== SYSTEM INFORMATION =====\n";
    system("lscpu | grep 'Model name'");
    system("free -h | grep 'Mem'");
    system("uptime -p");
    logAction("Displayed system information.");
    cleanOldLogs();
    cleanOldBackups();
}

void performBackup() {
    std::vector<std::string> skipList = {"backup", "logs", "snap", "proc", "sys", "dev", "run"};
    std::string src = "./";
    std::string dest = "backup/";
    fs::create_directories(dest);

    auto now = std::chrono::system_clock::now();
    auto time = std::chrono::system_clock::to_time_t(now);
    std::string backupFolder = dest + std::string("backup_") + std::to_string(time);

    try {
        fs::create_directories(backupFolder);

        for (const auto &entry : fs::directory_iterator(src)) {
            std::string folderName = entry.path().filename().string();

            if (std::find(skipList.begin(), skipList.end(), folderName) != skipList.end())
                continue;

            if (fs::is_directory(entry)) {
                fs::copy(entry, backupFolder + "/" + folderName, fs::copy_options::recursive | fs::copy_options::skip_existing);
            } else if (fs::is_regular_file(entry)) {
                fs::copy(entry, backupFolder + "/" + folderName, fs::copy_options::skip_existing);
            }
        }

        std::cout << "Backup completed successfully at: " << backupFolder << "\n";
        logAction("Backup created successfully.");
    } catch (std::exception &e) {
        std::cerr << "Backup failed: " << e.what() << "\n";
        logAction("Backup failed.");
    }

    cleanOldLogs();
    cleanOldBackups();
}

void cleanTempFiles() {
    std::cout << "\nCleaning user temporary files...\n";
    system("find /tmp -user $USER -type f -exec rm -f {} + 2>/dev/null >/dev/null");
    std::cout << "Temporary files cleaned successfully.\n";
    logAction("Temporary files cleaned.");

    cleanOldLogs();
    cleanOldBackups();
}

void showDiskUsage() {
    std::cout << "\n===== DISK USAGE =====\n";
    system("df -h --total | grep total");
    logAction("Displayed disk usage.");

    cleanOldLogs();
    cleanOldBackups();
}

int main() {
    fs::create_directories("logs");
    int choice;

    do {
        std::cout << "\n==============================\n";
        std::cout << "   SYSTEM MAINTENANCE TOOL\n";
        std::cout << "==============================\n";
        std::cout << "1. Show System Information\n";
        std::cout << "2. Backup Files\n";
        std::cout << "3. Clean Temporary Files\n";
        std::cout << "4. Show Disk Usage\n";
        std::cout << "5. Exit\n";
        std::cout << "Enter your choice: ";
        std::cin >> choice;

        switch (choice) {
            case 1: showSystemInfo(); break;
            case 2: performBackup(); break;
            case 3: cleanTempFiles(); break;
            case 4: showDiskUsage(); break;
            case 5:
                std::cout << "Exiting program.\n";
                logAction("Program exited.");
                cleanOldLogs();
                cleanOldBackups();
                break;
            default:
                std::cout << "Invalid choice. Try again.\n";
                break;
        }

    } while (choice != 5);

    return 0;
}
