local module = {
    Name = "Ubuntu.Arm64.20.04"
}

-- System
module.System = {
    Type = "Linux",
    Name = "Ubuntu",
    Version = "20.04",

    Host = {
        Platform = "arm64"
    },
    Target = {
        Platform = "arm64"
    }
}

-- Gcc
module.Gcc = {
    Command = "gcc-10"
}

-- Git
module.Git = {
    Command = "git"
}

-- CMake
module.CMake = {
    Command = "cmake",
    Generator = "Ninja Multi-Config",
    C = {
        Compiler = module.Gcc.Command
    }
}
-- CTest
module.CTest = {
    Command = "ctest"
}
-- CPack
module.CPack = {
    Command = "cpack"
}

-- 7-Zip
module.SevenZip = {
    Command = "7za"
}

-- NuGet
module.NuGet = {
    Command = "nuget",
    RuntimeID = "ubuntu." .. module.System.Version .. "-" .. module.System.Target.Platform
}

return module
