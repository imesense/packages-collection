$Source      = "https://github.com/bombomby/optick.git"
$Branch      = "1.4.0.0"
$Destination = "dep/bombomby/optick/$Branch"

$Output = "out"

function Invoke-Get {
    if (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
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

    cmake `
        -S $Destination `
        -B $Destination/build/Win32 `
        -G "Visual Studio 17 2022" `
        -A Win32 `
        -T host=x64 `
        -D OPTICK_ENABLED=ON `
        -D OPTICK_USE_D3D12=ON
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D OPTICK_ENABLED=ON `
        -D OPTICK_USE_D3D12=ON `
        -D OPTICK_USE_VULKAN=ON

    cmake --build $Destination/build/Win32 --config Debug
    cmake --build $Destination/build/Win32 --config Release
    cmake --build $Destination/build/x64 --config Debug
    cmake --build $Destination/build/x64 --config Release
}

function Invoke-Pack {
    nuget pack $PSScriptRoot\ImeSense.Packages.Optick.nuspec -OutputDirectory $Output
}

function Invoke-Actions {
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}
