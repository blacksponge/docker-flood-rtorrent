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

  touch /flood/.done
fi

if [[ ${NODE_ENV} == "production" ]]; then
  exec npm start
elif [[ ${NODE_ENV} == "development" ]]; then
  npm start:development
fi
