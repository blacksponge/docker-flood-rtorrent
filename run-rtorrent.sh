if [ -f .session/rtorrent.lock ]; then
  rm -f .session/rtorrent.lock
fi

exec rtorrent
