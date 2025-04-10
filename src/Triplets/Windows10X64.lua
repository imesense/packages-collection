local module = {
    Name = "Windows10X64"
}

module.Commands = {
    Git = "git",
    SevenZip = "/bin/7za.exe",

    CMake = "cmake",
    CTest = "ctest",
    CPack = "cpack",

    NuGet = "nuget"
}

module.System = {
    Name = "Windows",
    Platform = "x64"
}

module.WindowsSdk = {
    Version = "10.0.19041.0",
    Subsystem = ""
}

module.VisualStudio = {
    Version = "17",
    Year = "2022"
}

module.VisualCpp = {
    Version = "14.43",
    Platform = "amd64"
}

module.RuntimeID =
    "win." .. module.WindowsSdk.Version ..
    "-" .. module.System.Platform

module.CMakeGenerator =
    "Visual Studio " .. module.VisualStudio.Version .. " " .. module.VisualStudio.Year

return module
