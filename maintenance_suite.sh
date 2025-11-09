#!/bin/bash
<<<<<<< HEAD
# ==========================================
# System Maintenance Suite (Wipro Project)
# Name: Abhaya Sahoo
# Regd.no: 2241019019
# Description: Automates backups, system updates, and log cleanup with a menu interface.
# ==========================================

BACKUP_DIR="$HOME/project/System-Monitor-Tool-cpp/backups"
LOG_DIR="$HOME/project/System-Monitor-Tool-cpp/logs"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# ---------- Function: Backup ----------
backup_system() {
    echo "Starting system backup..."
    TS=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/system_backup_${TS}.tar.gz"
    LOG_FILE="$LOG_DIR/backup_${TS}.log"

    FOLDERS=(
        "$HOME/Documents"
        "$HOME/Desktop"
        "$HOME/Downloads"
        "$HOME/Pictures"
        "$HOME/Videos"
        "$HOME/project"
    )

    EXISTING_FOLDERS=()
    for folder in "${FOLDERS[@]}"; do
        if [ -d "$folder" ]; then
            EXISTING_FOLDERS+=("$folder")
        fi
    done

    if [ ${#EXISTING_FOLDERS[@]} -eq 0 ]; then
        echo "No valid folders found to back up!" | tee -a "$LOG_FILE"
        return
    fi

    tar -czf "$BACKUP_FILE" "${EXISTING_FOLDERS[@]}" --ignore-failed-read --warning=no-file-changed 2>>"$LOG_FILE"

    if [ $? -eq 0 ]; then
        echo "Backup completed successfully at $BACKUP_FILE"
    else
        echo "Backup finished with some warnings. Check log: $LOG_FILE"
    fi

    find "$BACKUP_DIR" -type f -mtime +7 -exec rm -f {} \;
    find "$LOG_DIR" -type f -mtime +7 -exec rm -f {} \;
}

# ---------- Function: Update & Cleanup ----------
update_cleanup() {
    echo "Starting system update and cleanup..."
    TS=$(date +"%Y%m%d_%H%M%S")
    LOG_FILE="$LOG_DIR/update_${TS}.log"

    {
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt autoremove -y
        sudo apt clean
    } >>"$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "System updated and cleaned successfully."
    else
        echo "Some issues occurred during update. Check log: $LOG_FILE"
    fi

    find "$LOG_DIR" -type f -mtime +7 -exec rm -f {} \;
}

# ---------- Function: System Info ----------
system_info() {
    echo "System Information:"
    echo "CPU Load: $(uptime | awk -F'load average:' '{ print $2 }')"
    echo "Memory Usage:"
    free -h
    echo "Disk Usage:"
    df -h | grep '^/dev'
}

# ---------- Function: Scheduler ----------
schedule_tasks() {
    echo "Setting up cron jobs for automatic maintenance..."

    CRON_JOB1="0 21 * * * bash $HOME/project/System-Monitor-Tool-cpp/maintenance_suite.sh backup"
    CRON_JOB2="0 0 * * * bash $HOME/project/System-Monitor-Tool-cpp/maintenance_suite.sh update"

    (crontab -l 2>/dev/null; echo "$CRON_JOB1"; echo "$CRON_JOB2") | crontab -

    echo "Scheduled backup at 9 PM and update at 12 AM daily."
}

# ---------- Function: Menu ----------
show_menu() {
    while true; do
        echo ""
        echo "==============================="
        echo "SYSTEM MAINTENANCE SUITE"
        echo "==============================="
        echo "1. Run Backup"
        echo "2. Run System Update & Cleanup"
        echo "3. View System Info"
        echo "4. Schedule Automatic Tasks"
        echo "5. Exit"
        echo "==============================="
        read -p "Select an option [1-5]: " choice

        case $choice in
            1) backup_system ;;
            2) update_cleanup ;;
            3) system_info ;;
            4) schedule_tasks ;;
            5) echo "Exiting Maintenance Suite."; exit 0 ;;
            *) echo "Invalid choice. Try again." ;;
        esac
    done
}

# ---------- Command Mode ----------
case "$1" in
    backup) backup_system ;;
    update) update_cleanup ;;
    info) system_info ;;
    schedule) schedule_tasks ;;
    *) show_menu ;;
esac
=======
# ============================================================
# 🧰 System Maintenance Suite
# Author: Abhaya Sahoo
# Description: Automates backups, updates, cleanup & log checks
# ============================================================

LOG_DIR="$HOME/system_logs"
BACKUP_DIR="$HOME/system_backups"
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

# Function: Backup System
backup_system() {
    LOG_FILE="$LOG_DIR/backup_$(date +%Y%m%d_%H%M%S).log"
    BACKUP_FILE="$BACKUP_DIR/system_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    echo "🔁 Starting system backup..." | tee -a "$LOG_FILE"
    tar -czf "$BACKUP_FILE" /home 2>>"$LOG_FILE"
    echo "✅ Backup completed successfully!" | tee -a "$LOG_FILE"
    echo "📦 Backup stored at: $BACKUP_FILE" | tee -a "$LOG_FILE"

    # Retention Policy (delete backups older than 7 days)
    find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \; 2>/dev/null
    echo "🧹 Old backups cleaned (retention 7 days)." | tee -a "$LOG_FILE"
}

# Function: Update & Cleanup
update_cleanup() {
    LOG_FILE="$LOG_DIR/update_cleanup_$(date +%Y%m%d_%H%M%S).log"
    echo "🔄 Updating and cleaning system..." | tee -a "$LOG_FILE"
    sudo apt update -y && sudo apt upgrade -y | tee -a "$LOG_FILE"
    sudo apt autoremove -y && sudo apt autoclean -y | tee -a "$LOG_FILE"
    echo "✅ System updated and cleaned successfully!" | tee -a "$LOG_FILE"
}

# Function: Log Monitoring
log_monitor() {
    LOG_FILE="$LOG_DIR/log_monitor_$(date +%Y%m%d_%H%M%S).log"
    echo "🔍 Monitoring logs for errors/warnings..." | tee -a "$LOG_FILE"
    sudo grep -Ei "error|fail|critical|warning" /var/log/* 2>/dev/null | tee -a "$LOG_FILE"
    echo "✅ Log monitoring completed." | tee -a "$LOG_FILE"
    echo "📜 Results saved to $LOG_FILE"
}

# Function: Push to GitHub (optional)
push_to_github() {
    echo "📦 Adding all changes..."
    git add .
    echo "🧾 Committing changes..."
    git commit -m "Maintenance Suite Update - $(date '+%Y-%m-%d %H:%M:%S')"
    echo "☁️ Pushing to GitHub..."
    git push origin main || git push origin master
    echo "✅ Push complete!"
}

# Main Menu
while true; do
    clear
    echo "=============================================="
    echo "🧰 SYSTEM MAINTENANCE SUITE - BY ABHAYA SAHOO"
    echo "=============================================="
    echo "1️⃣  Backup System"
    echo "2️⃣  Update & Cleanup"
    echo "3️⃣  Log Monitoring"
    echo "4️⃣  Push Code to GitHub"
    echo "5️⃣  Exit"
    echo "----------------------------------------------"
    read -p "👉 Enter your choice (1-5): " choice

    case $choice in
        1) backup_system ;;
        2) update_cleanup ;;
        3) log_monitor ;;
        4) push_to_github ;;
        5) echo "👋 Exiting... Goodbye!"; exit 0 ;;
        *) echo "❌ Invalid option! Please try again."; sleep 1 ;;
    esac
    echo "----------------------------------------------"
    read -p "Press Enter to continue..."
done

>>>>>>> 
