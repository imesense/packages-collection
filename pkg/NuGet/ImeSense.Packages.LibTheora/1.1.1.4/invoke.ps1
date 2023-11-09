$Source      = "https://gitlab.xiph.org/xiph/theora.git"
$Commit      = "7ffd8b2ecfc2d93ae5e16028e7528e609266bfbf"
$Branch      = "v1.1.1"
$Destination = "dep/xiph/theora/$Branch"

$Root   = "../../../.."
$Output = "out"

$LibOgg = "dep/xiph/ogg/v1.3.5"

function Invoke-Get {
    if (!(Test-Path -Path $Destination -ErrorAction SilentlyContinue)) {
        git clone --branch $Branch --depth 1 $Source $Destination
    }
}

function Invoke-Patch {
    Set-Location $Destination
    git reset --hard $Commit
    git am --3way --ignore-space-change --keep-cr $PSScriptRoot\0001-Migrate-libtheora_dynamic-solution-to-Visual-Studio-.patch
    git am --3way --ignore-space-change --keep-cr  $PSScriptRoot\0002-Fix-building-issues.patch
    Set-Location $Root

    Copy-Item -Path $Destination/README -Destination $Destination/README.md
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

    msbuild $Destination/win32/VS2008/libtheora_dynamic.sln `
        -p:Configuration=Debug `
        -p:Platform=Win32 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination/win32/VS2008/libtheora_dynamic.sln `
        -p:Configuration=Release_SSE2 `
        -p:Platform=Win32 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination/win32/VS2008/libtheora_dynamic.sln `
        -p:Configuration=Debug `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination/win32/VS2008/libtheora_dynamic.sln `
        -p:Configuration=Release_SSE2 `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
}

function Invoke-Pack {
    nuget pack $PSScriptRoot\ImeSense.Packages.LibTheora.nuspec -OutputDirectory $Output
}

function Invoke-Actions {
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}
