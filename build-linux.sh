#!/usr/bin/env bash

# Build release packages
source ./pkg/NuGet/ImeSense.Packages.GameNetworkingSockets.Vcpkg/1.4.1/invoke-linux.sh
source ./pkg/NuGet/onetbb/2021.11.0.1/invoke-linux.sh
source ./pkg/NuGet/lzo/2.10/invoke-linux.sh
source ./pkg/NuGet/mimalloc/2.1.7.3/invoke-linux.sh
source ./pkg/NuGet/sdl/2.28.5.2/invoke-linux.sh

# Build release packages
source ./pkg/NuGet/nvtt/2024.6.1-open/invoke-linux.sh
source ./pkg/NuGet/onetbb/2024.3.26.3-open/invoke-linux.sh
source ./pkg/NuGet/opus/2024.5.22-open/invoke-linux.sh
source ./pkg/NuGet/sdl/2023.12.9.1-open/invoke-linux.sh
source ./pkg/NuGet/sdl/2024.3.16-open/invoke-linux.sh
source ./pkg/NuGet/speexdsp/2024.6.4.1-open/invoke-linux.sh
