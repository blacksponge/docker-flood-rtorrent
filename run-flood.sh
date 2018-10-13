#!/bin/bash
export NODE_ENV=${NODE_ENV:-production}

if [ ! -f /flood/.done ]; then
  echo "Installing dependencies..."
  npm install
  npm install --only=dev
  echo "Copying config..."
  cp config.docker.js config.js
  
  if [[ ${NODE_ENV} == "production" ]]; then
    npm run build
  fi

  node << EOF
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
    console.log(user)
    process.exit(0)
  });
EOF

  touch /flood/.done
fi

if [[ ${NODE_ENV} == "production" ]]; then
  exec npm start
elif [[ ${NODE_ENV} == "development" ]]; then
  npm start:development
fi
