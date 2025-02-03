$Source      = "https://github.com/castano/nvidia-texture-tools.git"
$Commit      = "aeddd65f81d36d8cb7b169b469ef25156666077e"
$Branch      = ""
$Destination = "dep/castano/nvidia-texture-tools/$Commit"

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
        Write-Host
    }
}

function Invoke-Patch
{
    Write-Host "Patching sources..." -ForegroundColor Green
    Write-Host

    # Apply patches
    Set-Location $Destination
    git reset `
        --hard `
        $Commit
    git am `
        --3way `
        --ignore-space-change `
        --keep-cr `
        $PSScriptRoot\patch\0001-Upgrade-toolchain.patch
    git am `
        --3way `
        --ignore-space-change `
        --keep-cr `
        $PSScriptRoot\patch\0002-Delete-conflicting-functions.patch
    Set-Location $Root
}

function Invoke-Build
{
    # Invoke Visual Studio toolchain
    Write-Host
    Write-Host "Launching Visual Studio toolchain..." -ForegroundColor Green
    Write-Host
    . "$PSScriptRoot\$Root\src\invoke-vscmd.ps1"
    Invoke-VSCmd

    # Build (Win32)
    Write-Host
    Write-Host "Building Win32 Debug target..." -ForegroundColor Green
    msbuild `
        $Destination/project/vc2017/nvtt.sln `
        -p:Configuration=Debug `
        -p:Platform=Win32 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    Write-Host
    Write-Host "Building Win32 Release target..." -ForegroundColor Green
    msbuild `
        $Destination/project/vc2017/nvtt.sln `
        -p:Configuration=Release `
        -p:Platform=Win32 `
        -maxCpuCount `
        -nologo `
        -v:minimal

    # Build (x64)
    Write-Host
    Write-Host "Building x64 Debug target..." -ForegroundColor Green
    msbuild `
        $Destination/project/vc2017/nvtt.sln `
        -p:Configuration=Debug `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    Write-Host
    Write-Host "Building x64 Release target..." -ForegroundColor Green
    msbuild `
        $Destination/project/vc2017/nvtt.sln `
        -p:Configuration=Release `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
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

    Write-Host
    Write-Host "Packing symbols..." -ForegroundColor Green
    Write-Host
    nuget pack $PSScriptRoot\nuspec\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\nuspec\symbols.win-x64.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\nuspec\symbols.win-x86.nuspec -OutputDirectory $Output
}

function Invoke-Actions
{
    Invoke-Get
    Invoke-Patch
    Invoke-Build
    Invoke-Pack
}

Invoke-Actions
