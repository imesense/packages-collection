$Source      = "https://github.com/wxWidgets/wxWidgets.git"
$Branch      = "v3.2.4"
$Destination = "dep/wxWidgets/wxWidgets/$Branch"

$Name    = "wxwidgets"
$Version = "3.2.4"

$Root    = "../../../.."
$Output  = "out"
$Objects = "obj"

Function Invoke-Get {
    If (!(Test-Path -Path "$Destination" -ErrorAction SilentlyContinue)) {
        git clone --branch $Branch --depth 1 $Source $Destination
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
    nuget pack $PSScriptRoot\ImeSense.Packages.WxWidgets.Vcpkg.symbols.nuspec -OutputDirectory $Output
    Move-Item -Path "$Output/ImeSense.Packages.WxWidgets.Vcpkg.3.2.4.nupkg" -Destination "$Output/ImeSense.Packages.WxWidgets.Vcpkg.3.2.4.symbols.nupkg"
    nuget pack $PSScriptRoot\ImeSense.Packages.WxWidgets.Vcpkg.nuspec -OutputDirectory $Output
}

Function Invoke-Actions {
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}
