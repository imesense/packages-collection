# Build release packages
. .\build-windows.ps1 -Type NuGet -Name fidelityfx.fsr2.directx11 -Version 2.2.1.1
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.FreeType        -Version 2.13.2
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.LibOgg          -Version 1.3.5.5
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.LibTheora       -Version 1.1.1.4
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.LibVorbis       -Version 1.3.7.5
. .\build-windows.ps1 -Type NuGet -Name onetbb -Version 2021.11.0
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.OpenALSoft      -Version 1.23.1.2
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Optick          -Version 1.4.0
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Sdl             -Version 2.28.5
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Sdl             -Version 2.28.5.1
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.WxWidgets.Vcpkg -Version 3.2.4
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Zlib            -Version 1.2.13.3

# Build pre-release packages
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.FreeImage.WinMerge -Version 2023.8.19-open
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.FreeType           -Version 2023.12.7-open
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.LuaJIT             -Version 2.1.0-beta3
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Marl               -Version 2023.11.29-open
. .\build-windows.ps1 -Type NuGet -Name onetbb -Version 2024.3.26.3-open
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.OpenALSoft         -Version 2023.11.8-open
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Optick             -Version 2022.7.8-open
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Sdl                -Version 2023.12.9-open
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Sdl                -Version 2023.12.9.1-open
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Sdl                -Version 2023.12.9.2-open
. .\build-windows.ps1 -Type NuGet -Name ImeSense.Packages.Sdl                -Version 2024.3.16-open
