local module = {
    Name = "Ubuntu.X64.20.04"
}

module.Commands = {
    Git = "git",
    SevenZip = "7za",

    CMake = "cmake",
    CTest = "ctest",
    CPack = "cpack",

    NuGet = "mono ./bin/nuget"
}

module.System = {
    Name = "Ubuntu",
    Platform = "x64",
    Version = "20.04"
}

module.Compiler = "gcc-10"

module.RuntimeID =
    "ubuntu." .. module.System.Version ..
    "-" .. module.System.Platform

module.CMakeGenerator =
    "Ninja Multi-Config"

return module
