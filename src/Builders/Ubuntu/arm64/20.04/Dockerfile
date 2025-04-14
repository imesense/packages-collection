FROM arm64v8/ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt update && \
    apt upgrade -y && \
    rm -rf /var/lib/apt/lists/*

RUN \
    apt update && \
    apt install -y --no-install-recommends \
        ca-certificates \
        gpg \
        wget \
        build-essential \
        gcc-10 \
        ninja-build \
        git \
        p7zip-full \
        unzip && \
    rm -rf /var/lib/apt/lists/*

RUN \
    test -f /usr/share/doc/kitware-archive-keyring/copyright || \
        wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
        gpg --dearmor - | \
        tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | \
        tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt update && \
    apt install -y --no-install-recommends \
        kitware-archive-keyring \
        cmake-data \
        cmake && \
    rm -rf /var/lib/apt/lists/*

CMD [ "/bin/bash" ]
