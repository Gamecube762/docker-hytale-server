FROM openjdk:26-ea-25-slim-bookworm

RUN apt update && apt install -y --no-install-recommends curl unzip 

# User for running rootless
RUN groupadd --gid 1000 hytale && \
    useradd --uid 1000 --gid 1000 -m hytale && \
    mkdir /app /server && \
    chown -R hytale:hytale /server

COPY start.sh /app

USER hytale
WORKDIR /server
VOLUME /server
EXPOSE 5520/udp

CMD [ "/app/start.sh" ]
