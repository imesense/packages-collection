$Source      = "https://github.com/oneapi-src/oneTBB.git"
$Commit      = "8b829acc65569019edb896c5150d427f288e8aba"
$Branch      = "v2021.11.0"
$Destination = "dep/oneapi-src/oneTBB/$Branch"

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
        -D TBB_TEST=OFF
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/x64/install `
        -D TBB_TEST=OFF

    cmake --build $Destination/build/Win32 --config Debug
    cmake --build $Destination/build/Win32 --config RelWithDebInfo
    cmake --build $Destination/build/x64 --config Debug
    cmake --build $Destination/build/x64 --config RelWithDebInfo

    cmake --install $Destination/build/Win32 --config Debug
    cmake --install $Destination/build/Win32 --config RelWithDebInfo
    cmake --install $Destination/build/x64 --config Debug
    cmake --install $Destination/build/x64 --config RelWithDebInfo

    Set-Location $Destination
    git am --3way --ignore-space-change --keep-cr $PSScriptRoot\0001-Set-Windows-7-version.patch
    Set-Location $Root

    cmake `
        -S $Destination `
        -B $Destination/build/Win32-w7 `
        -G "Visual Studio 17 2022" `
        -A Win32 `
        -T host=x64 `
        -D CMAKE_SYSTEM_VERSION="10.0.19041.0" `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/Win32-w7/install `
        -D TBB_TEST=OFF
    cmake `
        -S $Destination `
        -B $Destination/build/x64-w7 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -D CMAKE_SYSTEM_VERSION="10.0.19041.0" `
        -D CMAKE_INSTALL_PREFIX=$Destination/build/x64-w7/install `
        -D TBB_TEST=OFF

    cmake --build $Destination/build/Win32-w7 --config Debug
    cmake --build $Destination/build/Win32-w7 --config RelWithDebInfo
    cmake --build $Destination/build/x64-w7 --config Debug
    cmake --build $Destination/build/x64-w7 --config RelWithDebInfo

    cmake --install $Destination/build/Win32-w7 --config Debug
    cmake --install $Destination/build/Win32-w7 --config RelWithDebInfo
    cmake --install $Destination/build/x64-w7 --config Debug
    cmake --install $Destination/build/x64-w7 --config RelWithDebInfo
}

Function Invoke-Pack {
    nuget pack $PSScriptRoot\metapackage.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win7-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win7-x64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win7-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win7-x64.nuspec -OutputDirectory $Output
}

Function Invoke-Actions {
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}
