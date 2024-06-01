#!/usr/bin/env bash

# Build release packages
source ./pkg/NuGet/ImeSense.Packages.GameNetworkingSockets.Vcpkg/1.4.1/invoke-macos.sh
source ./pkg/NuGet/onetbb/2021.11.0/invoke-macos.sh
source ./pkg/NuGet/mimalloc/2.1.7.1/invoke-macos.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2.28.5.1/invoke-macos.sh

# Build pre-release packages
source ./pkg/NuGet/nvtt/2024.6.1-open/invoke-macos.sh
source ./pkg/NuGet/onetbb/2024.3.26.3-open/invoke-macos.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2023.12.9.1-open/invoke-macos.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2023.12.9.2-open/invoke-macos.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2024.3.16-open/invoke-macos.sh
