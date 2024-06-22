$Branch      = "0.1"
$Destination = "dep/BearIvan/RedImage/$Branch"

$Root   = "../../../.."
$Output = "out"

Function Invoke-Build {
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

    msbuild $Destination/RedImage.sln `
        -p:Configuration=Debug `
        -p:Platform=x86 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination/RedImage.sln `
        -p:Configuration=Release `
        -p:Platform=x86 `
        -maxCpuCount `
        -nologo `
        -v:minimal

    msbuild $Destination/RedImage.sln `
        -p:Configuration=Debug `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
    msbuild $Destination/RedImage.sln `
        -p:Configuration=Release `
        -p:Platform=x64 `
        -maxCpuCount `
        -nologo `
        -v:minimal
}

Function Invoke-Pack {
    nuget pack $PSScriptRoot\metapackage.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\runtimes.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\runtimes.win-x64.nuspec -OutputDirectory $Output

    nuget pack $PSScriptRoot\symbols.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x86.nuspec -OutputDirectory $Output
    nuget pack $PSScriptRoot\symbols.win-x64.nuspec -OutputDirectory $Output
}

Function Invoke-Actions {
    Invoke-Build
    Invoke-Pack
}
