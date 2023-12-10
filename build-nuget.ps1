# Build release packages
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.FreeImage.WinMerge -Version 3.18.0.20230819
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.LibOgg             -Version 1.3.5.5
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.LibTheora          -Version 1.1.1.4
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.LibVorbis          -Version 1.3.7.5
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.OpenALSoft         -Version 1.23.1.2
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.Optick             -Version 1.4.0
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.Zlib               -Version 1.2.13.3

# Build pre-release packages
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.LuaJIT     -Version 2.1.0-beta3
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.Marl       -Version 2023.11.29-open
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.OpenALSoft -Version 2023.11.8-open
. .\build.ps1 -Type NuGet -Name ImeSense.Packages.Optick     -Version 2022.7.8-open
