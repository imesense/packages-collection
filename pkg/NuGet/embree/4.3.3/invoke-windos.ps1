$Source      = "https://github.com/RenderKit/embree.git"
$Commit      = ""
$Branch      = "v4.3.3"
$Destination = "dep/RenderKit/embree/$Branch"

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

function Invoke-Build
{
    # Invoke Visual Studio toolchain
    Write-Host "Launching Visual Studio toolchain..." -ForegroundColor Green
    Write-Host
    . "$PSScriptRoot\$Root\src\invoke-vscmd.ps1"
    Invoke-VSCmd

    # Configure (Win32 and x64)
    Write-Host
    Write-Host "Configuring Win32 target..." -ForegroundColor Green
    Write-Host
    cmake `
        -S $Destination `
        -B $Destination/build/Win32 `
        -G "Visual Studio 17 2022" `
        -A Win32 `
        -T host=x64 `
        -D TBB_ROOT=dep/oneapi-src/oneTBB/v2021.11.0/build/Win32-w7/install/lib/cmake/TBB `
        -D BUILD_SHARED_LIBS=ON `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/Win32/install `
        -D CPACK_SOURCE_7Z=OFF `
        -D CPACK_SOURCE_ZIP=OFF `
        -D EMBREE_TUTORIALS=OFF `
        -D EMBREE_ZIP_MODE=OFF
    Write-Host
    Write-Host "Configuring x64 target..." -ForegroundColor Green
    Write-Host
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D TBB_ROOT=dep/oneapi-src/oneTBB/v2021.11.0/build/x64-w7/install/lib/cmake/TBB `
        -D BUILD_SHARED_LIBS=ON `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/x64/install `
        -D CPACK_SOURCE_7Z=OFF `
        -D CPACK_SOURCE_ZIP=OFF `
        -D EMBREE_TUTORIALS=OFF `
        -D EMBREE_ZIP_MODE=OFF

    # Build (Win32 and x64)
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

    # Install (Win32 and x64)
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

    Write-Host
    Write-Host "Packing symbols..." -ForegroundColor Green
    Write-Host
    nuget pack $PSScriptRoot\nuspec\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\nuspec\symbols.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\nuspec\symbols.win-x64.nuspec -OutputDirectory $Output
}

function Invoke-Actions
{
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}

Invoke-Actions
