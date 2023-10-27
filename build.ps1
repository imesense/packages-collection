param (
    [Parameter(Mandatory=$true)]
    [string] $Type,

    [Parameter(Mandatory=$true)]
    [string] $Name,

    [Parameter(Mandatory=$true)]
    [string] $Version
)

. .\pkg\$Type\$Name\$Version\invoke.ps1
Invoke-Actions
