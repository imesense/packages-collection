local module = {
    Name = "Windows.X64ToX86.10.0.19041"
}

-- System
module.System = {
    Type = "Windows",
    Name = "Windows",
    Version = "10.0.19041.0",
    Subsystem = "Desktop",

    Host = {
        Platform = "x64"
    },
    Target = {
        Platform = "x86"
    }
}

-- Visual Studio
module.VisualStudio = {
    Version = "2022",
    VersionMajor = "17"
}
-- Visual C++
module.VisualCpp = {
    Version = "14.43",
    Platform = "x86"
}

-- Git
module.Git = {
    Command = "git"
}

-- CMake
module.CMake = {
    Command = "cmake.exe",
    Generator = {
        Name = "Visual Studio " .. module.VisualStudio.VersionMajor .. " " .. module.VisualStudio.Version,
        Target = "Win32"
    }
}
-- CTest
module.CTest = {
    Command = "ctest.exe"
}
-- CPack
module.CPack = {
    Command = "cpack.exe"
}

-- 7-Zip
module.SevenZip = {
    Command = "7za.exe"
}

-- NuGet
module.NuGet = {
    Command = "nuget.exe",
    RuntimeID = "win" .. module.System.Version .. "-" .. module.System.Target.Platform
}

return module
