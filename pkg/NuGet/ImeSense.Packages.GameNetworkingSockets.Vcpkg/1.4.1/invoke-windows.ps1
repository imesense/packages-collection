$Source      = "https://github.com/ValveSoftware/GameNetworkingSockets.git"
$Branch      = "v1.4.1"
$Destination = "dep/ValveSoftware/GameNetworkingSockets/$Branch"

$Name    = "gamenetworkingsockets"
$Version = "1.4.1"

$Root    = "../../../.."
$Output  = "out"
$Objects = "obj"

Function Invoke-Get {
    If (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone --branch $Branch --depth 1 $Source $Destination
        Copy-Item -Path $Destination/LICENSE -Destination $Destination/LICENSE.txt
    }

    If (!(Test-Path -Path $Objects/$Name/$Version -ErrorAction SilentlyContinue)) {
        New-Item -Name $Objects/$Name/$Version -ItemType Directory
        New-Item -Name $Objects/$Name/$Version/x86 -ItemType Directory
        New-Item -Name $Objects/$Name/$Version/x86-64 -ItemType Directory
    }

    Copy-Item -Path $PSScriptRoot/vcpkg.json -Destination $Objects/$Name/$Version/x86
    Copy-Item -Path $PSScriptRoot/vcpkg.json -Destination $Objects/$Name/$Version/x86-64
}

Function Invoke-Build {
    Set-Location -Path $Objects/$Name/$Version/x86
    vcpkg install --triplet=x86-windows

    Set-Location -Path ../x86-64
    vcpkg install --triplet=x64-windows

    Set-Location $Root
}

Function Invoke-Pack {
    nuget pack $PSScriptRoot\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\metapackage.nuspec -OutputDirectory $Output
}

Function Invoke-Actions {
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}
