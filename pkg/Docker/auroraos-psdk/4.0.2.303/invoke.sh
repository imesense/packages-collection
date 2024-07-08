#!/usr/bin/env bash

branch="4.0.2"
version="4.0.2.303"

invoke_get() {
    if [ ! -d "tar" ]; then
        mkdir -p tar
    fi

    curl -o tar/Aurora_OS-$version-base-Aurora_Platform_SDK_Chroot-i486.tar.bz2 \
        https://sdk-repo.omprussia.ru/sdk/installers/$branch/PlatformSDK/$version/Aurora_OS-$version-base-Aurora_Platform_SDK_Chroot-i486.tar.bz2
    curl -o tar/Aurora_OS-$version-base-Aurora_SDK_Tooling-i486.tar.bz2 \
        https://sdk-repo.omprussia.ru/sdk/installers/$branch/PlatformSDK/$version/Aurora_OS-$version-base-Aurora_SDK_Tooling-i486.tar.bz2
    curl -o tar/Aurora_OS-$version-base-Aurora_SDK_Target-i486.tar.bz2 \
        https://sdk-repo.omprussia.ru/sdk/installers/$branch/PlatformSDK/$version/Aurora_OS-$version-base-Aurora_SDK_Target-i486.tar.bz2
    curl -o tar/Aurora_OS-$version-base-Aurora_SDK_Target-armv7hl.tar.bz2 \
        https://sdk-repo.omprussia.ru/sdk/installers/$branch/PlatformSDK/$version/Aurora_OS-$version-base-Aurora_SDK_Target-armv7hl.tar.bz2
}

invoke_build() {
    docker buildx build \
        -t gitea.imesense.ru/imesense/auroraos-psdk:$version-amd64 \
        -f "Dockerfile" \
        --platform amd64 \
        --load \
        .
    docker buildx build \
        -t gitea.imesense.ru/imesense/auroraos-psdk:$version-i386 \
        -f "Dockerfile" \
        --platform i386 \
        --load \
        .

    docker push \
        gitea.imesense.ru/imesense/auroraos-psdk:$version-amd64
    docker push \
        gitea.imesense.ru/imesense/auroraos-psdk:$version-i386

    docker buildx imagetools create \
        -t gitea.imesense.ru/imesense/auroraos-psdk:$version \
        gitea.imesense.ru/imesense/auroraos-psdk:$version-amd64 \
        gitea.imesense.ru/imesense/auroraos-psdk:$version-i386
}

invoke_actions() {
    invoke_get
    invoke_build
}

invoke_actions
