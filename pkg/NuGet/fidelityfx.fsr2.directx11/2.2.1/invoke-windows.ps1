$Source      = "https://github.com/GPUOpen-Effects/FidelityFX-FSR2.git"
$Commit      = "1680d1edd5c034f88ebbbb793d8b88f8842cf804"
$Branch      = "v2.2.1"
$Destination = "dep/GPUOpen-Effects/FidelityFX-FSR2/$Branch"

$Root   = "../../../.."
$Output = "out"

$UrpSource      = "https://github.com/GPUOpen-Effects/FidelityFX-FSR2-Unity-URP.git"
$UrpCommit      = "5cf7c6bc306b992036bba7563415905ed9c6e32c"
$UrpDestination = "dep/GPUOpen-Effects/FidelityFX-FSR2-Unity-URP/$UrpCommit"

Function Invoke-Get {
    If (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone --recursive --branch $Branch --depth 1 $Source $Destination
    }
    If (!(Test-Path -Path "$UrpDestination" -ErrorAction SilentlyContinue)) {
        git clone $UrpSource $UrpDestination
    }
}

Function Invoke-Patch {
    Set-Location $Destination
    git reset --hard $Commit
    git am --3way --ignore-space-change --keep-cr $Root\$UrpDestination\src\patch\0001-fsr-2.2-dx11-backend.patch
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

    Set-Location $Destination\build
    . ./GenerateSolutionDX11DLL.bat
    Set-Location DX11
    msbuild FSR2_Sample.sln `
        -p:Configuration=Debug `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild FSR2_Sample.sln `
        -p:Configuration=RelWithDebInfo `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    Set-Location ..\..
    Set-Location $Root
}

Function Invoke-Pack {
    nuget pack $PSScriptRoot\metapackage.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x64.nuspec -OutputDirectory $Output
}

Function Invoke-Actions {
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}
