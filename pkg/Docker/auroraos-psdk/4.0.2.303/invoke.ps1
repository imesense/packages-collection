$Branch = "4.0.2"
$Version = "4.0.2.303"

Function Invoke-Get {
    If (!(Test-Path -Path "tar" -ErrorAction SilentlyContinue)) {
        New-Item -Name tar -ItemType directory
    }

    Invoke-WebRequest `
        -Uri "https://sdk-repo.omprussia.ru/sdk/installers/$Branch/PlatformSDK/$Version/Aurora_OS-$Version-base-Aurora_Platform_SDK_Chroot-i486.tar.bz2" `
        -OutFile "tar\Aurora_OS-$Version-base-Aurora_Platform_SDK_Chroot-i486.tar.bz2"
    Invoke-WebRequest `
        -Uri "https://sdk-repo.omprussia.ru/sdk/installers/$Branch/PlatformSDK/$Version/Aurora_OS-$Version-base-Aurora_SDK_Tooling-i486.tar.bz2" `
        -OutFile "tar\Aurora_OS-$Version-base-Aurora_SDK_Tooling-i486.tar.bz2"
    Invoke-WebRequest `
        -Uri "https://sdk-repo.omprussia.ru/sdk/installers/$Branch/PlatformSDK/$Version/Aurora_OS-$Version-base-Aurora_SDK_Target-i486.tar.bz2" `
        -OutFile "tar\Aurora_OS-$Version-base-Aurora_SDK_Target-i486.tar.bz2"
    Invoke-WebRequest `
        -Uri "https://sdk-repo.omprussia.ru/sdk/installers/$Branch/PlatformSDK/$Version/Aurora_OS-$Version-base-Aurora_SDK_Target-armv7hl.tar.bz2" `
        -OutFile "tar\Aurora_OS-$Version-base-Aurora_SDK_Target-armv7hl.tar.bz2"
}

Function Invoke-Build {
    docker buildx build `
        -t gitea.imesense.ru/imesense/auroraos-psdk:$Version-amd64 `
        -f "Dockerfile" `
        --platform amd64 `
        --load `
        .
    docker buildx build `
        -t gitea.imesense.ru/imesense/auroraos-psdk:$Version-i386 `
        -f "Dockerfile" `
        --platform i386 `
        --load `
        .

    docker push `
        gitea.imesense.ru/imesense/auroraos-psdk:$Version-amd64
    docker push `
        gitea.imesense.ru/imesense/auroraos-psdk:$Version-i386

    docker buildx imagetools create `
        -t gitea.imesense.ru/imesense/auroraos-psdk:$Version `
        gitea.imesense.ru/imesense/auroraos-psdk:$Version-amd64 `
        gitea.imesense.ru/imesense/auroraos-psdk:$Version-i386
}

Function Invoke-Actions {
    Invoke-Get
    Invoke-Build
}

Invoke-Actions
