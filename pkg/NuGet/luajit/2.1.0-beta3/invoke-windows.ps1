$Source      = "https://github.com/LuaJIT/LuaJIT.git"
$Branch      = "v2.1.0-beta3"
$Destination = "dep/LuaJIT/LuaJIT/$Branch"

$Root   = "../../../.."
$Output = "out"

function Invoke-Get
{
    if (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue))
    {
        git clone --branch $Branch --depth 1 $Source $Destination
    }
}

function Invoke-Patch
{
    Copy-Item -Path $Destination/README -Destination $Destination/README.md
}

function Invoke-Build
{
    if (!(Test-Path -Path $Destination/out -ErrorAction SilentlyContinue))
    {
        New-Item -Name $Destination/out/debug/x86 -ItemType directory
        New-Item -Name $Destination/out/debug/x64 -ItemType directory
        New-Item -Name $Destination/out/release/x86 -ItemType directory
        New-Item -Name $Destination/out/release/x64 -ItemType directory
    }

    & $PSScriptRoot/build-debug-x86.bat
    Move-Item -Path "$Destination/src/*.exe" -Destination "$Destination/out/debug/x86/"
    Move-Item -Path "$Destination/src/*.dll" -Destination "$Destination/out/debug/x86/"
    Move-Item -Path "$Destination/src/*.pdb" -Destination "$Destination/out/debug/x86/"
    Move-Item -Path "$Destination/src/*.lib" -Destination "$Destination/out/debug/x86/"
    Move-Item -Path "$Destination/src/*.exp" -Destination "$Destination/out/debug/x86/"

    & $PSScriptRoot/build-debug-x64.bat
    Move-Item -Path "$Destination/src/*.exe" -Destination "$Destination/out/debug/x64/"
    Move-Item -Path "$Destination/src/*.dll" -Destination "$Destination/out/debug/x64/"
    Move-Item -Path "$Destination/src/*.pdb" -Destination "$Destination/out/debug/x64/"
    Move-Item -Path "$Destination/src/*.lib" -Destination "$Destination/out/debug/x64/"
    Move-Item -Path "$Destination/src/*.exp" -Destination "$Destination/out/debug/x64/"

    & $PSScriptRoot/build-release-x86.bat
    Move-Item -Path "$Destination/src/*.exe" -Destination "$Destination/out/release/x86/"
    Move-Item -Path "$Destination/src/*.dll" -Destination "$Destination/out/release/x86/"
    Move-Item -Path "$Destination/src/*.pdb" -Destination "$Destination/out/release/x86/"
    Move-Item -Path "$Destination/src/*.lib" -Destination "$Destination/out/release/x86/"
    Move-Item -Path "$Destination/src/*.exp" -Destination "$Destination/out/release/x86/"

    & $PSScriptRoot/build-release-x64.bat
    Move-Item -Path "$Destination/src/*.exe" -Destination "$Destination/out/release/x64/"
    Move-Item -Path "$Destination/src/*.dll" -Destination "$Destination/out/release/x64/"
    Move-Item -Path "$Destination/src/*.pdb" -Destination "$Destination/out/release/x64/"
    Move-Item -Path "$Destination/src/*.lib" -Destination "$Destination/out/release/x64/"
    Move-Item -Path "$Destination/src/*.exp" -Destination "$Destination/out/release/x64/"
}

function Invoke-Pack
{
    nuget pack $PSScriptRoot\package.nuspec -OutputDirectory $Output
}

function Invoke-Actions
{
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}

Invoke-Actions
