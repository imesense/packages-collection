$Source      = "https://gitlab.xiph.org/xiph/speexdsp.git"
$Commit      = "dbd421d149a9c362ea16150694b75b63d757a521"
$Destination = "dep/xiph/speexdsp/$Commit"

$Root   = "../../../.."
$Output = "out"

Function Invoke-Get {
    If (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone $Source $Destination
    }
}

Function Invoke-Patch {
    Set-Location $Destination
    git reset --hard $Commit
    git am --3way --ignore-space-change --keep-cr  $PSScriptRoot\0001-Add-CMake-project.patch
    git am --3way --ignore-space-change --keep-cr  $PSScriptRoot\0002-Fix-library-exports-on-Windows.patch
    Copy-Item -Path README -Destination README.md
    Copy-Item -Path COPYING -Destination LICENSE.txt
    Set-Location $Root
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
        -D BUILD_SHARED_LIBS=ON `
        -D FIXED_POINT=OFF `
        -D USE_SSE=ON `
        -D USE_NEON=OFF
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/x64/install `
        -D BUILD_SHARED_LIBS=ON `
        -D FIXED_POINT=OFF `
        -D USE_SSE=ON `
        -D USE_NEON=OFF

    cmake `
        -S $Destination `
        -B $Destination/build/ARM `
        -G "Visual Studio 17 2022" `
        -A ARM `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/ARM/install `
        -D BUILD_SHARED_LIBS=ON `
        -D FIXED_POINT=OFF `
        -D USE_SSE=OFF `
        -D USE_NEON=ON
    cmake `
        -S $Destination `
        -B $Destination/build/ARM64 `
        -G "Visual Studio 17 2022" `
        -A ARM64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/ARM64/install `
        -D BUILD_SHARED_LIBS=ON `
        -D FIXED_POINT=OFF `
        -D USE_SSE=OFF `
        -D USE_NEON=ON

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

Function Invoke-Pack {
    nuget pack $PSScriptRoot\metapackage.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-arm.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-arm64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-arm.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-arm64.nuspec -OutputDirectory $Output
}

Function Invoke-Actions {
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}
