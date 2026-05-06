# BTGS Coin Explorer

Public block explorer for the BTGS Coin network, built on the eIquidus community explorer codebase.

## Live Explorer

- Explorer: https://explorer.btgs.nitopool.online/
- Official website: https://bitcoingold.site/
- Source wallet and daemon: https://github.com/BTGSCOINDEV/BTGS
- X: https://x.com/BTGSGOLD
- Discord: https://discord.gg/MCZNAtvpcV

## Features

- Block, transaction, and address search
- Latest blocks and transactions
- Network statistics and difficulty information
- Address balances and transaction history
- Rich list / top holder pages
- Address label claim system
- Public API endpoints for explorer data

## Installation

This guide is for running an independent BTGS Coin explorer instance.

### Requirements

- Linux server, preferably Ubuntu 22.04 or newer
- Node.js 20.x and npm
- MongoDB
- Synced BTGS daemon with RPC enabled
- BTGS daemon built with the required RPC support
- Optional: Nginx or another reverse proxy for HTTPS

### BTGS Daemon Configuration

Create or update the BTGS daemon config with local RPC enabled. Replace all placeholder values before starting the daemon.

```ini
server=1
daemon=1
txindex=1
rpcbind=127.0.0.1
rpcallowip=127.0.0.1
rpcuser=CHANGE_ME_RPC_USER
rpcpassword=CHANGE_ME_RPC_PASSWORD
rpcport=18881
```

Start the daemon and wait for full synchronization before running the explorer sync.

### MongoDB Setup

Create a dedicated MongoDB database and user for the explorer.

```javascript
use btgs_explorerdb
db.createUser({
  user: "btgs_explorer",
  pwd: "CHANGE_ME_MONGO_PASSWORD",
  roles: ["readWrite"]
})
```

### Explorer Setup

```bash
git clone https://github.com/biigbang0001/explorer-eIquidus-BTGS.git
cd explorer-eIquidus-BTGS
npm install
cp settings.json.template settings.json
```

Edit `settings.json` and configure:

- MongoDB connection in `dbsettings`
- BTGS RPC connection in `wallet`
- Web server port in `webserver.port`
- A unique value for `plugins.plugin_secret_code`
- Any branding, market, or page options needed for the deployment

`settings.json` is intentionally ignored by Git and must remain private.

## Running the Explorer

Start the web process:

```bash
npm start
```

Run the blockchain sync:

```bash
npm run sync-blocks
```

For production, a process manager such as PM2 can be used:

```bash
pm2 start ./bin/instance --name btgs-explorer
pm2 save
```

A helper sync wrapper is included:

```bash
chmod +x sync-btgs.sh
./sync-btgs.sh
```

### Recommended Nginx Protection

When the explorer is public, run it behind Nginx with HTTPS and per-IP rate limiting. Example:

```nginx
limit_req_zone $binary_remote_addr zone=btgs_explorer_limit:10m rate=20r/s;

server {
    listen 443 ssl http2;
    server_name explorer.example.com;

    location / {
        limit_req zone=btgs_explorer_limit burst=80 nodelay;
        limit_req_status 429;

        proxy_pass http://127.0.0.1:8094;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_hide_header X-Powered-By;
    }
}
```

Keep the Node.js explorer port private whenever possible and expose only Nginx publicly.

## Maintenance

Common maintenance commands:

```bash
npm run sync-blocks
npm run reindex-rich
npm run market
```

If the daemon is reindexed or the explorer database is rebuilt, allow the explorer to finish syncing before relying on rich list, transaction, or address totals.

## Security Notes

- Keep BTGS RPC bound to localhost unless remote access is explicitly required.
- Do not expose MongoDB publicly.
- Do not commit `settings.json`, wallet files, database dumps, SSL private keys, or RPC credentials.
- Use unique passwords for MongoDB, RPC, and plugin integrations.
- Put the explorer behind HTTPS when exposing it publicly.

## Credits

BTGS Coin Explorer is based on the eIquidus community explorer project and customized for BTGS Coin.

## License

This project follows the license terms included in this repository.
