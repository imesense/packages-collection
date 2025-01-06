$Source      = "http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz"
$Branch      = "lzo-2.10"
$Destination = "dep/lzo/lzo/$Branch"

$Root   = "../../../.."
$Output = "out"

function Invoke-Get
{
    if (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue))
    {
        New-Item -Name $Destination -ItemType Directory
    }

    if (!(Test-Path -Path "$Destination/../lzo-2.10.tar.gz" -ErrorAction SilentlyContinue))
    {
        Invoke-WebRequest -Uri $Source -OutFile $Destination/../lzo-2.10.tar.gz

        Set-Location $Destination/..
        tar -xf lzo-2.10.tar.gz

        Set-Location lzo-2.10
        git init
        git add .
        git commit -m "Initial commit"

        Set-Location $Root
    }
}

function Invoke-Patch
{
    Set-Location $Destination
    git reset --hard HEAD~1
    git am --3way --ignore-space-change --keep-cr $PSScriptRoot\0001-Enable-exports-for-Windows-build.patch
    Set-Location $Root

    Copy-Item -Path $Destination/README -Destination $Destination/README.md
    Copy-Item -Path $Destination/COPYING -Destination $Destination/LICENSE.txt
}

function Invoke-Build
{
    $installer = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $path      = & $installer -latest -prerelease -property installationPath

    Push-Location "$path\Common7\Tools"
    cmd /c "VsDevCmd.bat&set" |
    ForEach-Object
    {
        if ($_ -Match "=")
        {
            $v = $_.Split("=", 2)
            Set-Item -Force -Path "ENV:\$($v[0])" -Value "$($v[1])"
        }
    }
    Pop-Location
    Write-Host "Visual Studio 2022 Command Prompt" -ForegroundColor Yellow

    cmake `
        -S $Destination `
        -B $Destination/build/Win32 `
        -G "Visual Studio 17 2022" `
        -A Win32 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/Win32/install `
        -D ENABLE_STATIC=OFF `
        -D ENABLE_SHARED=ON
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/x64/install `
        -D ENABLE_STATIC=OFF `
        -D ENABLE_SHARED=ON

    cmake `
        -S $Destination `
        -B $Destination/build/ARM `
        -G "Visual Studio 17 2022" `
        -A ARM `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/ARM/install `
        -D ENABLE_STATIC=OFF `
        -D ENABLE_SHARED=ON
    cmake `
        -S $Destination `
        -B $Destination/build/ARM64 `
        -G "Visual Studio 17 2022" `
        -A ARM64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/ARM64/install `
        -D ENABLE_STATIC=OFF `
        -D ENABLE_SHARED=ON

    cmake --build $Destination/build/Win32 --config Debug
    cmake --build $Destination/build/Win32 --config RelWithDebInfo
    cmake --build $Destination/build/x64 --config Debug
    cmake --build $Destination/build/x64 --config RelWithDebInfo

    cmake --build $Destination/build/ARM --config Debug
    cmake --build $Destination/build/ARM --config RelWithDebInfo
    cmake --build $Destination/build/ARM64 --config Debug
    cmake --build $Destination/build/ARM64 --config RelWithDebInfo

    cmake --install $Destination/build/Win32 --config Debug
    cmake --install $Destination/build/Win32 --config RelWithDebInfo
    cmake --install $Destination/build/x64 --config Debug
    cmake --install $Destination/build/x64 --config RelWithDebInfo

    cmake --install $Destination/build/ARM --config Debug
    cmake --install $Destination/build/ARM --config RelWithDebInfo
    cmake --install $Destination/build/ARM64 --config Debug
    cmake --install $Destination/build/ARM64 --config RelWithDebInfo
}

function Invoke-Pack
{
    nuget pack $PSScriptRoot\metapackage.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-arm.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-arm64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-arm.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-arm64.nuspec -OutputDirectory $Output
}

function Invoke-Actions
{
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}

Invoke-Actions
