local module = {
    Name = "WindowsX64"
}

module.Commands = {
    Git = "git",
    SevenZip = "./bin/7za.exe",

    CMake = "./bin/cmake.exe",
    CTest = "./bin/ctest.exe",
    CPack = "./bin/cpack.exe",

    NuGet = "./bin/nuget.exe"
}

module.System = {
    Name = "Windows",
    Platform = "amd64"
}

module.Toolchain = {
    VisualStudio = "17",
    VisualCpp = "14.43",

    WindowsSdk = "10.0.19041.0",
    WindowsSubsystem = ""
}

return module
