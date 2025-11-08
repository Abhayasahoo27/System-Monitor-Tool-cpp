#!/bin/bash
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

