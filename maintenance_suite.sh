#!/bin/bash
# ============================================
# System Maintenance Suite (Day 1 + Day 2)
# Author: Abhaya Sahoo
# ============================================

# === Setup ===
LOG_DIR="$HOME/system_logs"
BACKUP_DIR="$HOME/backups"
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

LOG_FILE="$LOG_DIR/maintenance_suite_$(date +%Y%m%d_%H%M%S).log"

# === Logging function ===
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# === MENU ===
while true; do
    clear
    echo "=============================="
    echo "   🧰 SYSTEM MAINTENANCE MENU"
    echo "=============================="
    echo "1️⃣  Backup Important Files"
    echo "2️⃣  Update and Clean System"
    echo "3️⃣  Exit"
    echo "=============================="
    read -p "Choose an option [1-3]: " choice

    case $choice in
        1)
            log "\n📦 Starting system backup at: $(date)"
            SRC_DIR="$HOME/Documents"
            BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).tar.gz"
            tar -czf "$BACKUP_FILE" "$SRC_DIR" 2>>"$LOG_FILE"
            log "✅ Backup completed successfully!"
            log "🗂️ Backup saved at: $BACKUP_FILE"
            read -p "Press Enter to return to menu..."
            ;;
        
        2)
            log "\n🧽 Starting system update and cleanup at: $(date)"

            UPDATE_CMD="apt update -y"
            UPGRADE_CMD="apt upgrade -y"
            AUTOREMOVE_CMD="apt autoremove -y"
            CLEAN_CMD="apt clean"

            if [[ $EUID -ne 0 ]]; then
                log "⚠️  Running without root privileges. Using sudo..."
                UPDATE_CMD="sudo $UPDATE_CMD"
                UPGRADE_CMD="sudo $UPGRADE_CMD"
                AUTOREMOVE_CMD="sudo $AUTOREMOVE_CMD"
                CLEAN_CMD="sudo $CLEAN_CMD"
            fi

            log "Updating package lists..."
            $UPDATE_CMD >>"$LOG_FILE" 2>&1

            log "Upgrading packages..."
            $UPGRADE_CMD >>"$LOG_FILE" 2>&1

            log "Removing unused packages..."
            $AUTOREMOVE_CMD >>"$LOG_FILE" 2>&1

            log "Cleaning package cache..."
            $CLEAN_CMD >>"$LOG_FILE" 2>&1

            log "💾 Disk space after cleanup:"
            df -h | tee -a "$LOG_FILE"

            log "✅ Update & cleanup completed!"
            read -p "Press Enter to return to menu..."
            ;;

        3)
            log "\n👋 Exiting Maintenance Suite. Goodbye!"
            log "🗂️ Log file saved at: $LOG_FILE"
            exit 0
            ;;

        *)
            echo "❌ Invalid choice. Please enter 1–3."
            sleep 1
            ;;
    esac
done
