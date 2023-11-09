$Source      = "https://gitlab.xiph.org/xiph/ogg.git"
$Branch      = "v1.3.5"
$Destination = "dep/xiph/ogg/$Branch"

$Output = "out"

function Invoke-Get {
    if (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone --branch $Branch --depth 1 $Source $Destination
    }
}

function Invoke-Build {
    $installer = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $path      = & $installer -latest -prerelease -property installationPath

    pushd "$path\Common7\Tools"
    cmd /c "VsDevCmd.bat&set" |
    foreach {
        if ($_ -Match "=") {
            $v = $_.Split("=", 2)
            Set-Item -Force -Path "ENV:\$($v[0])" -Value "$($v[1])"
        }
    }
    popd
    Write-Host "Visual Studio 2022 Command Prompt" -ForegroundColor Yellow

    cmake `
        -S $Destination `
        -B $Destination/build/Win32 `
        -G "Visual Studio 17 2022" `
        -A Win32 `
        -T host=x64 `
        -DBUILD_SHARED_LIBS=ON `
        -DBUILD_TESTING=OFF
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -DBUILD_SHARED_LIBS=ON `
        -DBUILD_TESTING=OFF

    cmake --build $Destination/build/Win32 --config Debug
    cmake --build $Destination/build/Win32 --config Release
    cmake --build $Destination/build/x64 --config Debug
    cmake --build $Destination/build/x64 --config Release
}

function Invoke-Pack {
    nuget pack $PSScriptRoot\ImeSense.Packages.LibOgg.nuspec -OutputDirectory $Output
}

function Invoke-Actions {
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}
