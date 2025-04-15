local module = {
    Name = "MacOS.arm64.11.0"
}

module.Commands = {
    Git = "git",
    SevenZip = "7za",

    CMake = "cmake",
    CTest = "ctest",
    CPack = "cpack",

    NuGet = "nuget"
}

module.System = {
    Name = "MacOS",
    Platform = "arm64",
    Version = "11.0"
}

module.RuntimeID =
    "osx." .. module.System.Version ..
    "-" .. module.System.Platform

module.CMakeGenerator =
    "Xcode"

return module
