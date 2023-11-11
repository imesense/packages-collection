$Source      = "https://github.com/WinMerge/freeimage.git"
$Commit      = "f4ffb561f3c9da43b4bdf2f6cc552fe34bd9da23"
$Destination = "dep/WinMerge/freeimage/$Commit"

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

    msbuild $Destination\FreeImage.vs2022.sln `
        -p:Configuration=Debug `
        -p:Platform=x86 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination\FreeImage.vs2022.sln `
        -p:Configuration=Release `
        -p:Platform=x86 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination\FreeImage.vs2022.sln `
        -p:Configuration=Debug `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination\FreeImage.vs2022.sln `
        -p:Configuration=Release `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
}

function Invoke-Pack {
    nuget pack $PSScriptRoot\ImeSense.Packages.FreeImage.WinMerge.nuspec -OutputDirectory $Output
}

function Invoke-Actions {
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}
