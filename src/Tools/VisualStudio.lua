-- Local imports
local mappers = require("src.Common.Mappers")
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")
local utilities = require("src.Common.Utilities")

-- Current module
local module = {
    Name = "VisualStudio"
}

local windowsSdk = Triplet.System.Version
local windowsSubsystem = mappers.MapWindowsSubsystem(Triplet.System.Subsystem)

local visualStudioVersion = Triplet.VisualStudio.VersionMajor

local visualCppVersion = Triplet.VisualCpp.Version
local visualCppPlatform = Triplet.VisualCpp.Platform

function module.FindFolder(version)
    local programFilesX86 = utilities.GetEnvironmentVariable("ProgramFiles(x86)")
    local application = programFilesX86 .. "\\Microsoft Visual Studio\\Installer\\vswhere.exe"
    if not filesystem.Exists(application) then
        console.PrintColor("Error: vswhere does not exists", console.Colors.Red)
        return nil
    end

    local path = console.ExecuteCommand(
        "\"" .. application .. "\"" ..
        " -version " .. version ..
        " -property installationPath"
    )
    if not path or path == "" then
        console.PrintColor("Error: Visual Studio does not exists", console.Colors.Red)
        return nil
    end
    return utilities.TrimString(path)
end

function module.RunDevCmd(command)
    local vsdevcmd =
        "call " ..
        "\"" ..
        module.FindFolder(visualStudioVersion) ..
        "\\VC\\Auxiliary\\Build\\vcvarsall.bat" ..
        "\" " ..
        visualCppPlatform .. " " ..
        windowsSubsystem .. " " ..
        windowsSdk ..
        " -vcvars_ver=" .. visualCppVersion
    local result = console.ExecuteCommand(
        vsdevcmd ..
        " && " ..
        utilities.TrimString(command)
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

return module
