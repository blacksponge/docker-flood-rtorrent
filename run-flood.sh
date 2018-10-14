#!/bin/bash
export NODE_ENV=${NODE_ENV:-production}

BLUE='\033[0;36m'
NC='\033[0m'

function log {
  echo -e "${BLUE}$@${NC}"
}

if [ ! -f /flood/.done ]; then
  log "Installing dependencies..."
  npm install
  npm install --only=dev
  log "Copying config..."
  cp config.docker.js config.js
  
  if [[ ${NODE_ENV} == "production" ]]; then
    log "Building static assets..."
    npm run build
  fi
  log "Creating default user..."
  msgUser=$(node << EOF
const Users = require('./server/models/Users')
Users.createUser({
  username: process.env.FLOOD_USER,
  password: process.env.FLOOD_PASSWORD,
  host: process.env.RTORRENT_SCGI_HOST,
  port: process.env.RTORRENT_SCGI_PORT,
  socketPath: null,
  isAdmin: true}, (user, err) => {
    if (err) {
      console.error(err)
      process.exit(1)
    }
    console.log(user.username)
    process.exit(0)
  });
EOF
)
  result=$?
  if [[ $result -eq 1 ]]; then
    >&2 echo -e "Could not create user $FLOOD_USER\n$msgUser"
    exit 1
  else
    log "User $msgUser created"
  fi

  touch /flood/.done
fi

log "Starting flood for ${NODE_ENV}"

if [[ ${NODE_ENV} == "production" ]]; then
  exec npm start
elif [[ ${NODE_ENV} == "development" ]]; then
  npm run start:development:server &
  npm run start:development:client
fi
