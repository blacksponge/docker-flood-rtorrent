# Flood + rtorrent docker images

## Installation notes

In order to deploy the two images run `docker-compose up`. The defaults run rtorrent with the user having an UID of 1000, to change it to your local user if it differs, export the UID before running `docker-compose` :

```sh
export UID
docker-compose up
```

Flood should then be reachable at http://localhost:3000, a default account `admin` is available using the password `changeme`.  

To add new torrents add them through the webui or simply drop them in `./watch/load` or `./watch/start` if you want them to start automatically.
