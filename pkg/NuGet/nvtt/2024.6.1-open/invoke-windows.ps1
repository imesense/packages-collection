$Source      = "https://github.com/imesense/nvidia-texture-tools.git"
$Commit      = "64930f757db91c1208dbb2d29ca454096889dac0"
$Destination = "dep/imesense/nvidia-texture-tools/$Commit"

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

    msbuild $Destination\project\vc2017\nvtt.sln `
        -p:Configuration=Debug `
        -p:Platform=Win32 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination\project\vc2017\nvtt.sln `
        -p:Configuration=Release `
        -p:Platform=Win32 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination\project\vc2017\nvtt.sln `
        -p:Configuration=Debug `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination\project\vc2017\nvtt.sln `
        -p:Configuration=Release `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
}

Function Invoke-Pack {
    nuget pack $PSScriptRoot\metapackage.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x64.nuspec -OutputDirectory $Output
}

Function Invoke-Actions {
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}
