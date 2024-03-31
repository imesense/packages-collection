#!/usr/bin/env bash

# Build release packages
source ./pkg/NuGet/ImeSense.Packages.GameNetworkingSockets.Vcpkg/1.4.1/invoke-linux.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2.28.5.1/invoke-linux.sh

# Build release packages
source ./pkg/NuGet/onetbb/2024.3.26-open/invoke-linux.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2023.12.9.1-open/invoke-linux.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2023.12.9.2-open/invoke-linux.sh
source ./pkg/NuGet/ImeSense.Packages.Sdl/2024.3.16-open/invoke-linux.sh
