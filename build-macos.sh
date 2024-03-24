#!/usr/bin/env bash

# Build release packages
source ./pkg/NuGet/ImeSense.Packages.GameNetworkingSockets.Vcpkg/1.4.1/invoke-macos.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2.28.5.1/invoke-macos.sh

# Build pre-release packages
source ./pkg/NuGet/ImeSense.Packages.Sdl/2023.12.9.1-open/invoke-macos.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2023.12.9.2-open/invoke-macos.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2024.3.16-open/invoke-macos.sh
