param (
    [Parameter(Mandatory=$true)]
    [string] $Type,

    [Parameter(Mandatory=$true)]
    [string] $Name,

    [Parameter(Mandatory=$true)]
    [string] $Version
)

if (!(Test-Path -Path pkg\$Type\$Name\$Version\invoke.ps1 -ErrorAction SilentlyContinue)) {
    . .\pkg\$Type\$Name\$Version\invoke-windows.ps1
} else {
    . .\pkg\$Type\$Name\$Version\invoke.ps1
}

Invoke-Actions
