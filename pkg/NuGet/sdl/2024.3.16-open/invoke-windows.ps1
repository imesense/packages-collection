$Source      = "https://github.com/libsdl-org/SDL.git"
$Commit      = "e5812a9fd2cda317b503325a702ba3c1c37861d9"
$Destination = "dep/libsdl-org/SDL/$Commit"

$Root   = "../../../.."
$Output = "out"

function Invoke-Get {
    if (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone $Source $Destination
    }
}

function Invoke-Patch {
    Set-Location $Destination
    git reset --hard $Commit
    Set-Location $Root
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
        -T host=x64
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64
    cmake `
        -S $Destination `
        -B $Destination/build/ARM `
        -G "Visual Studio 17 2022" `
        -A ARM `
        -T host=x64
    cmake `
        -S $Destination `
        -B $Destination/build/ARM64 `
        -G "Visual Studio 17 2022" `
        -A ARM64 `
        -T host=x64

    cmake --build $Destination/build/Win32 --config Debug
    cmake --build $Destination/build/Win32 --config RelWithDebInfo
    cmake --build $Destination/build/x64 --config Debug
    cmake --build $Destination/build/x64 --config RelWithDebInfo
    cmake --build $Destination/build/ARM --config Debug
    cmake --build $Destination/build/ARM --config RelWithDebInfo
    cmake --build $Destination/build/ARM64 --config Debug
    cmake --build $Destination/build/ARM64 --config RelWithDebInfo
}

function Invoke-Pack {
    nuget pack $PSScriptRoot\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-arm.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-arm64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-arm.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-arm64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\metapackage.nuspec -OutputDirectory $Output
}

function Invoke-Actions {
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}
