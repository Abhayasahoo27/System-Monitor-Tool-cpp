#!/bin/bash
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
