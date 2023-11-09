$Source      = "https://gitlab.xiph.org/xiph/vorbis.git"
$Branch      = "v1.3.7"
$Destination = "dep/xiph/vorbis/$Branch"

$Output = "out"

$LibOgg = "dep/xiph/ogg/v1.3.5"

function Invoke-Get {
    if (!(Test-Path -Path $Destination -ErrorAction SilentlyContinue)) {
        git clone --branch $Branch --depth 1 $Source $Destination
    }
}

function Invoke-Build {
    $installer = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $path      = & $installer -latest -prerelease -property installationPath

    Push-Location "$path\Common7\Tools"
    cmd /c "VsDevCmd.bat&set" |
    ForEach-Object {
        if ($_ -Match "=") {
            $v = $_.Split("=", 2)
            Set-Item -Force -Path "ENV:\$($v[0])" -Value "$($v[1])"
        }
    }
    Pop-Location
    Write-Host "Visual Studio 2022 Command Prompt" -ForegroundColor Yellow

    if (!(Test-Path -Path $Destination/build/dep -ErrorAction SilentlyContinue)) {
        New-Item -Name $Destination/build/dep/Win32/include/ogg -ItemType directory
        New-Item -Name $Destination/build/dep/x64/include/ogg -ItemType directory
    }

    Copy-Item -Path "$LibOgg/build/Win32/Release/ogg.dll" -Destination "$Destination/build/dep/Win32/ogg.dll"
    Copy-Item -Path "$LibOgg/build/Win32/Release/ogg.exp" -Destination "$Destination/build/dep/Win32/ogg.exp"
    Copy-Item -Path "$LibOgg/build/Win32/Release/ogg.lib" -Destination "$Destination/build/dep/Win32/ogg.lib"
    Copy-Item -Path "$LibOgg/build/x64/Release/ogg.dll" -Destination "$Destination/build/dep/x64/ogg.dll"
    Copy-Item -Path "$LibOgg/build/x64/Release/ogg.exp" -Destination "$Destination/build/dep/x64/ogg.exp"
    Copy-Item -Path "$LibOgg/build/x64/Release/ogg.lib" -Destination "$Destination/build/dep/x64/ogg.lib"

    Copy-Item -Path "$LibOgg/build/Win32/include/ogg/config_types.h" -Destination "$Destination/build/dep/Win32/include/ogg/config_types.h"
    Copy-Item -Path "$LibOgg/build/x64/include/ogg/config_types.h" -Destination "$Destination/build/dep/x64/include/ogg/config_types.h"
    Copy-Item -Path "$LibOgg/include/ogg/*.h" -Destination "$Destination/build/dep/Win32/include/ogg/"
    Copy-Item -Path "$LibOgg/include/ogg/*.h" -Destination "$Destination/build/dep/x64/include/ogg/"

    cmake `
        -S $Destination `
        -B $Destination/build/Win32 `
        -G "Visual Studio 17 2022" `
        -A Win32 `
        -T host=x64 `
        -DBUILD_SHARED_LIBS=ON `
        -DOGG_ROOT="build/dep/Win32"
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -DBUILD_SHARED_LIBS=ON `
        -DOGG_ROOT="build/dep/x64"

    cmake --build $Destination/build/Win32 --config Debug
    cmake --build $Destination/build/Win32 --config Release
    cmake --build $Destination/build/x64 --config Debug
    cmake --build $Destination/build/x64 --config Release
}

function Invoke-Pack {
    nuget pack $PSScriptRoot\ImeSense.Packages.LibVorbis.nuspec -OutputDirectory $Output
}

function Invoke-Actions {
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}
