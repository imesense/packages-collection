local module = {
    Name = "MacOS.Arm64ToX64.10.15"
}

-- System
module.System = {
    Type = "Darwin",
    Name = "MacOS",
    Version = "11.0",

    Host = {
        Platform = "arm64"
    },
    Target = {
        Platform = "x64"
    }
}

-- Git
module.Git = {
    Command = "git"
}

-- CMake
module.CMake = {
    Command = "cmake",
    Generator = {
        Name = "Xcode"
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
    RuntimeID = "osx." .. module.System.Version .. "-" .. module.System.Target.Platform
}

return module
