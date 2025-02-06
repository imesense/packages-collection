$Source      = "https://github.com/ixray-team/luajit-ixray.git"
$Commit      = ""
$Branch      = "d2025.2.5"
$Destination = "dep/ixray-team/luajit-ixray/$Branch"

$Root   = "../../../.."
$Output = "out"

function Invoke-Get
{
    # Get sources
    if (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue))
    {
        Write-Host "Getting sources..." -ForegroundColor Green
        Write-Host
        git clone `
            --branch $Branch `
            --depth 1 `
            $Source `
            $Destination
    }
}

function Invoke-Patch
{
    Copy-Item -Path $Destination/README -Destination $Destination/README.md
}

function Invoke-Build
{
    # Invoke Visual Studio toolchain
    Write-Host "Launching Visual Studio toolchain..." -ForegroundColor Green
    Write-Host
    . "$PSScriptRoot\$Root\src\invoke-vscmd.ps1"
    Invoke-VSCmd

    # Clean
    if (Test-Path -Path "$Destination\src\host\buildvm_arch.h" -ErrorAction SilentlyContinue)
    {
        Remove-Item -Path $Destination\src\host\buildvm_arch.h
        Remove-Item -Path $Destination\src\jit\vmdef.lua
        Remove-Item -Path $Destination\src\lj_bcdef.h
        Remove-Item -Path $Destination\src\lj_ffdef.h
        Remove-Item -Path $Destination\src\lj_folddef.h
        Remove-Item -Path $Destination\src\lj_libdef.h
        Remove-Item -Path $Destination\src\lj_recdef.h
    }

    # Configure (Win32)
    Write-Host
    Write-Host "Configuring Win32 target..." -ForegroundColor Green
    Write-Host
    cmake `
        -S $Destination `
        -B $Destination/build/Win32 `
        -G "Visual Studio 17 2022" `
        -A Win32 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/Win32/install

    # Build (Win32)
    Write-Host
    Write-Host "Building Win32 Debug target..." -ForegroundColor Green
    cmake `
        --build $Destination/build/Win32 `
        --config Debug `
        --parallel `
        -- `
        /nologo `
        /verbosity:minimal
    Write-Host
    Write-Host "Building Win32 RelWithDebInfo target..." -ForegroundColor Green
    cmake `
        --build $Destination/build/Win32 `
        --config RelWithDebInfo `
        --parallel `
        -- `
        /nologo `
        /verbosity:minimal

    # Install (Win32)
    Write-Host
    Write-Host "Installing Win32 Debug target..." -ForegroundColor Green
    Write-Host
    cmake `
        --install $Destination/build/Win32 `
        --config Debug
    Write-Host
    Write-Host "Installing Win32 RelWithDebInfo target..." -ForegroundColor Green
    Write-Host
    cmake `
        --install $Destination/build/Win32 `
        --config RelWithDebInfo

    # Clean
    if (Test-Path -Path "$Destination\src\host\buildvm_arch.h" -ErrorAction SilentlyContinue)
    {
        Remove-Item -Path $Destination\src\host\buildvm_arch.h
        Remove-Item -Path $Destination\src\jit\vmdef.lua
        Remove-Item -Path $Destination\src\lj_bcdef.h
        Remove-Item -Path $Destination\src\lj_ffdef.h
        Remove-Item -Path $Destination\src\lj_folddef.h
        Remove-Item -Path $Destination\src\lj_libdef.h
        Remove-Item -Path $Destination\src\lj_recdef.h
    }

    # Configure (x64)
    Write-Host
    Write-Host "Configuring x64 target..." -ForegroundColor Green
    Write-Host
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/x64/install

    # Build (x64)
    Write-Host
    Write-Host "Building x64 Debug target..." -ForegroundColor Green
    cmake `
        --build $Destination/build/x64 `
        --config Debug `
        --parallel `
        -- `
        /nologo `
        /verbosity:minimal
    Write-Host
    Write-Host "Building x64 RelWithDebInfo target..." -ForegroundColor Green
    cmake `
        --build $Destination/build/x64 `
        --config RelWithDebInfo `
        --parallel `
        -- `
        /nologo `
        /verbosity:minimal

    # Install (x64)
    Write-Host
    Write-Host "Installing x64 Debug target..." -ForegroundColor Green
    Write-Host
    cmake `
        --install $Destination/build/x64 `
        --config Debug
    Write-Host
    Write-Host "Installing x64 RelWithDebInfo target..." -ForegroundColor Green
    Write-Host
    cmake `
        --install $Destination/build/x64 `
        --config RelWithDebInfo
}

function Invoke-Pack
{
    Write-Host
    Write-Host "Packing metapackage..." -ForegroundColor Green
    Write-Host
    nuget pack $PSScriptRoot\nuspec\metapackage.nuspec -OutputDirectory $Output

    Write-Host
    Write-Host "Packing runtimes..." -ForegroundColor Green
    Write-Host
    nuget pack $PSScriptRoot\nuspec\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\nuspec\runtimes.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\nuspec\runtimes.win-x64.nuspec -OutputDirectory $Output
}

function Invoke-Actions
{
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}

Invoke-Actions
