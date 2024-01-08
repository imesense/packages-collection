$Source      = "https://github.com/nigels-com/glew.git"
$Branch      = "glew-2.2.0"
$Destination = "dep/nigels-com/glew/$Branch"

$Name    = "glew"
$Version = "2.2"

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
    nuget pack $PSScriptRoot\ImeSense.Packages.Glew.Vcpkg.nuspec -OutputDirectory $Output
}

Function Invoke-Actions {
    Invoke-Get
    Invoke-Build
    Invoke-Pack
}
