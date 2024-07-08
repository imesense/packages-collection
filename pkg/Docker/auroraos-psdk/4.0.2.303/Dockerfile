FROM scratch AS build

ARG PSDK_VERSION=4.0.2.303

ADD \
    tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_Platform_SDK_Chroot-i486.tar.bz2 \
    /

ARG USER=mersdk
RUN \
    useradd --create-home ${USER} && \
    echo "${USER}:" | chpasswd && \
    usermod -aG root ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME=/home/${USER}
USER ${USER}
WORKDIR ${HOME}

COPY \
    tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Tooling-i486.tar.bz2 \
    /tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Tooling-i486.tar.bz2
COPY \
    tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Target-i486.tar.bz2 \
    /tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Target-i486.tar.bz2
COPY \
    tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Target-armv7hl.tar.bz2 \
    /tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Target-armv7hl.tar.bz2

RUN \
    sdk-assistant tooling create \
        AuroraOS-${PSDK_VERSION}-base \
        /tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Tooling-i486.tar.bz2 \
        --no-snapshot \
        --non-interactive
RUN \
    sdk-assistant target create \
        AuroraOS-${PSDK_VERSION}-base-i486 \
        /tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Target-i486.tar.bz2 \
        --no-snapshot \
        --non-interactive
RUN \
    sdk-assistant target create \
        AuroraOS-${PSDK_VERSION}-base-armv7hl \
        /tar/Aurora_OS-${PSDK_VERSION}-base-Aurora_SDK_Target-armv7hl.tar.bz2 \
        --no-snapshot \
        --non-interactive

USER root

RUN \
    rm -rf /tar

FROM scratch AS result

LABEL \
    vendor="ImeSense" \
    maintainer="acidicMercury8 <acidicmercury8@outlook.com>" \
    version="1.0" \
    description="Aurora OS Platform SDK 4.0.2.303"

COPY --from=build / /

ARG USER=mersdk
ENV HOME=/home/${USER}
USER ${USER}
WORKDIR ${HOME}

CMD ["/bin/bash"]
