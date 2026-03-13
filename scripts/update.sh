#!/usr/bin/env bash
# CCBot Auto-Update Script
# Called by ccbot-update.timer every hour

set -euo pipefail

PROJECT_DIR="/home/asturwebs/bytia/proyectos/ccbot"
LOG_FILE="/home/asturwebs/bytia/laboratorio-ia/logs/ccbot-update.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cd "$PROJECT_DIR"

# Check for updates
log "Checking for updates..."

git fetch upstream 2>&1 | tee -a "$LOG_FILE"

LOCAL=$(git rev-parse HEAD)
UPSTREAM=$(git rev-parse upstream/main)

if [ "$LOCAL" = "$UPSTREAM" ]; then
    log "No updates available from upstream"
    exit 0
fi

log "Update available from upstream: $LOCAL -> $UPSTREAM"

# Pull changes from upstream
log "Pulling updates from upstream (six-ddc/ccmux)..."
git pull upstream main 2>&1 | tee -a "$LOG_FILE"

# Restart service
log "Restarting ccbot.service..."
systemctl --user restart ccbot.service

log "Update complete"
