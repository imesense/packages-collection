local module = {
    Name = "Windows10X86"
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
    Name = "Windows",
    Platform = "x86"
}

module.WindowsSdk = {
    Version = "10.0.19041.0",
    Subsystem = ""
}

module.VisualStudio = {
    Version = "17"
}

module.VisualCpp = {
    Version = "14.43",
    Platform = "x86"
}

return module
