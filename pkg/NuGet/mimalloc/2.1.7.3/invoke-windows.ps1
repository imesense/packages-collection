$Source      = "https://github.com/microsoft/mimalloc.git"
$Commit      = "8c532c32c3c96e5ba1f2283e032f69ead8add00f"
$Branch      = "v2.1.7"
$Destination = "dep/microsoft/mimalloc/$Branch"

$Root   = "../../../.."
$Output = "out"

Function Invoke-Get {
    If (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone --branch $Branch --depth 1 $Source $Destination
    }
}

Function Invoke-Patch {
    Set-Location $Destination
    git reset --hard $Commit
    git am --3way --ignore-space-change --keep-cr $PSScriptRoot\0001-Fix-incorrect-NULL-definitions.patch
    Copy-Item -Path LICENSE -Destination LICENSE.txt
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
        -D MI_BUILD_STATIC=OFF `
        -D MI_BUILD_OBJECT=OFF `
        -D MI_BUILD_TESTS=OFF
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/x64/install `
        -D MI_BUILD_STATIC=OFF `
        -D MI_BUILD_OBJECT=OFF `
        -D MI_BUILD_TESTS=OFF

    cmake `
        -S $Destination `
        -B $Destination/build/ARM `
        -G "Visual Studio 17 2022" `
        -A ARM `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/ARM/install `
        -D MI_BUILD_STATIC=OFF `
        -D MI_BUILD_OBJECT=OFF `
        -D MI_BUILD_TESTS=OFF
    cmake `
        -S $Destination `
        -B $Destination/build/ARM64 `
        -G "Visual Studio 17 2022" `
        -A ARM64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/ARM64/install `
        -D MI_BUILD_STATIC=OFF `
        -D MI_BUILD_OBJECT=OFF `
        -D MI_BUILD_TESTS=OFF

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
