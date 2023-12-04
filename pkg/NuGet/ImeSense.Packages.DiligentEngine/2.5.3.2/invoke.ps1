$Source      = "https://github.com/DiligentGraphics/DiligentEngine.git"
$Branch      = "v2.5.3"
$Destination = "dep/DiligentGraphics/DiligentEngine/$Branch"

$Output = "out"

Function Invoke-Get {
    If (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone --branch $Branch --depth 1 --recurse-submodules $Source $Destination
    }
}

Function Invoke-Build {
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
        -D CMAKE_INSTALL_PREFIX=$Destination/build/Win32/install `
        -D DILIGENT_BUILD_FX=FALSE `
        -D DILIGENT_BUILD_TOOLS=TRUE `
        -D DILIGENT_BUILD_SAMPLES=TRUE `
        -D DILIGENT_IMPROVE_SPIRV_TOOLS_DEBUG_PERF=TRUE `
        -D DILIGENT_INSTALL_CORE=TRUE `
        -D DILIGENT_INSTALL_PDB=TRUE `
        -D DILIGENT_INSTALL_TOOLS=TRUE `
        -D DILIGENT_NO_FORMAT_VALIDATION=TRUE `
        -D DILIGENT_NO_METAL=TRUE
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/x64/install `
        -D DILIGENT_BUILD_FX=FALSE `
        -D DILIGENT_BUILD_TOOLS=TRUE `
        -D DILIGENT_BUILD_SAMPLES=TRUE `
        -D DILIGENT_IMPROVE_SPIRV_TOOLS_DEBUG_PERF=TRUE `
        -D DILIGENT_INSTALL_CORE=TRUE `
        -D DILIGENT_INSTALL_PDB=TRUE `
        -D DILIGENT_INSTALL_TOOLS=TRUE `
        -D DILIGENT_NO_FORMAT_VALIDATION=TRUE `
        -D DILIGENT_NO_METAL=TRUE

    cmake --build $Destination/build/Win32 --config Debug
    cmake --build $Destination/build/Win32 --config Release
    cmake --build $Destination/build/x64 --config Debug
    cmake --build $Destination/build/x64 --config Release

    cmake --install $Destination/build/Win32 --config Debug
    cmake --install $Destination/build/Win32
    cmake --install $Destination/build/x64 --config Debug
    cmake --install $Destination/build/x64
}

function Invoke-Pack {
    nuget pack $PSScriptRoot\ImeSense.Packages.DiligentEngine.nuspec -OutputDirectory $Output
}

function Invoke-Actions {
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}
