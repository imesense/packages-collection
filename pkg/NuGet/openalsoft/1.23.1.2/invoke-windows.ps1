$Source      = "https://github.com/kcat/openal-soft.git"
$Branch      = "1.23.1"
$Destination = "dep/kcat/openal-soft/$Branch"

$Root   = "../../../.."
$Output = "out"

function Invoke-Get
{
    if (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone --branch $Branch --depth 1 $Source $Destination
    }
}

function Invoke-Build
{
    $installer = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $path      = & $installer -latest -prerelease -property installationPath

    Push-Location "$path\Common7\Tools"
    cmd /c "VsDevCmd.bat&set" |
    ForEach-Object
    {
        if ($_ -Match "=")
        {
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
        -DALSOFT_REQUIRE_WINMM=ON `
        -DALSOFT_REQUIRE_DSOUND=ON `
        -DALSOFT_REQUIRE_WASAPI=ON
    cmake `
        -S $Destination `
        -B $Destination/build/x64 `
        -G "Visual Studio 17 2022" `
        -A x64 `
        -T host=x64 `
        -DALSOFT_REQUIRE_WINMM=ON `
        -DALSOFT_REQUIRE_DSOUND=ON `
        -DALSOFT_REQUIRE_WASAPI=ON

    cmake --build $Destination/build/Win32 --config Debug
    cmake --build $Destination/build/Win32 --config Release
    cmake --build $Destination/build/x64 --config Debug
    cmake --build $Destination/build/x64 --config Release
}

function Invoke-Pack
{
    nuget pack $PSScriptRoot\package.nuspec -OutputDirectory $Output
}

function Invoke-Actions
{
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}

Invoke-Actions
