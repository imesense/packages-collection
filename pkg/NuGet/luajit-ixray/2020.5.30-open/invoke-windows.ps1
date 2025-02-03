$Source      = "https://github.com/LuaJIT/LuaJIT.git"
$Commit      = "f0e865dd4861520258299d0f2a56491bd9d602e1"
$Branch      = ""
$Destination = "dep/LuaJIT/LuaJIT-IXRay/$Commit"

$Root   = "../../../.."
$Output = "out"

function Invoke-Get
{
    # Get sources
    if (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue))
    {
        Write-Host "Getting sources..." -ForegroundColor Green
        Write-Host
        git clone `
            $Source `
            $Destination
    }
}

function Invoke-Patch
{
    Write-Host
    Write-Host "Patching sources..." -ForegroundColor Green
    Write-Host

    # Copy readme
    Copy-Item -Path $Destination\README -Destination $Destination\README.md

    # Apply patch
    Set-Location $Destination
    git reset `
        --hard $Commit
    git am `
        --3way `
        --ignore-space-change `
        --keep-cr `
        $PSScriptRoot\patch\0001-Fixed-LuaJit-for-Vanilla.patch
    Set-Location $Root
}

function Invoke-Build
{
    # Clean output folders
    if (Test-Path -Path "$Destination\out\x86" -ErrorAction SilentlyContinue)
    {
        Remove-Item -Path "$Destination\out\x86" -Recurse
    }
    if (Test-Path -Path "$Destination\out\x64" -ErrorAction SilentlyContinue)
    {
        Remove-Item -Path "$Destination\out\x64" -Recurse
    }

    # Make output folders
    New-Item -Name $Destination\out\x86 -ItemType directory
    New-Item -Name $Destination\out\x64 -ItemType directory

    # Build (x86)
    Write-Host
    Write-Host "Building x86 target..." -ForegroundColor Green
    & $PSScriptRoot\util\build-x86.bat
    Move-Item -Path "$Destination\src\*.dll" -Destination "$Destination\out\x86\"
    Move-Item -Path "$Destination\src\*.lib" -Destination "$Destination\out\x86\"
    Move-Item -Path "$Destination\src\*.exp" -Destination "$Destination\out\x86\"

    # Build (x64)
    Write-Host
    Write-Host "Building x64 target..." -ForegroundColor Green
    & $PSScriptRoot\util\build-x64.bat
    Move-Item -Path "$Destination\src\*.dll" -Destination "$Destination\out\x64\"
    Move-Item -Path "$Destination\src\*.lib" -Destination "$Destination\out\x64\"
    Move-Item -Path "$Destination\src\*.exp" -Destination "$Destination\out\x64\"
}

function Invoke-Pack
{
    Write-Host
    Write-Host "Packing metapackage..." -ForegroundColor Green
    Write-Host
    nuget pack $PSScriptRoot\nuspec\metapackage.nuspec -OutputDirectory $Output

    Write-Host
    Write-Host "Packing runtimes..." -ForegroundColor Green
    Write-Host
    nuget pack $PSScriptRoot\nuspec\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\nuspec\runtimes.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\nuspec\runtimes.win-x86.nuspec -OutputDirectory $Output
}

function Invoke-Actions
{
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}

Invoke-Actions
