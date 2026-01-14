# Hytale Server Docker 

A simple docker server to run a Hytale server.

## Usage:


### cli:

```sh
docker run -it \
    --name hytale-server \
    --restart unless-stopped \
    -p 5520:5520/udp \
    -v ./server:/server \
    ghcr.io/Gamecube762/docker-hytale-server:latest
```

### docker-compose.yml:
```yaml
services:
  hytale:
    image: ghcr.io/Gamecube762/docker-hytale-server:latest
    restart: unless-stopped
    ports:
      - "5520:5520/udp"
    volumes: 
      - ./server-data:/server
```

Note: You will likely need to authenticate the server before any user can join. This can be done with `/auth login device`.

## Known Issues

### /auth login web

The server opens a HTTP server on a random port to listen for the OAuth callback. Since this port is random, we can't predefine it when creating the docker container.

### /auth persistence Encrypted

`java.lang.RuntimeException: Failed to get hardware UUID for Linux - all methods failed`

Hytale currently cannot generate a hardware UUID in the docker container. It will not be able to persistently store the credentials and will be lost when the server stops/restarts.

### "Failed to connect: Server authentication unavailable"

The server needs to be authenticated before players can join. This can be done by two ways:

Use: /auth login device

Authenticate the server with the url provided. This will allow the server to authenticate clients as they join. However since credential persistence is not currently working, this will need to manually be done every time the server starts.

Or: offline-mode (Not recomended)

Alternatively you can start the server in offline mode by passing the argument `--auth-mode offline` to the container. This is only recomended for development use, running a production server with this will lead to issues.

