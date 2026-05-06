#!/bin/bash
(
  flock -n 9 || exit 0
  export NVM_DIR="/root/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  cd /var/btgs/explorer/explorer || exit 1
  npm run sync-blocks >> /var/btgs/explorer/explorer/sync-cron.log 2>&1
) 9>/tmp/btgs-explorer-sync.lock
