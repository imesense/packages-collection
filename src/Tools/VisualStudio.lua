-- Local imports
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")
local utilities = require("src.Common.Utilities")

-- Current module
local module = {
    Name = "VisualStudio",
    Triplet = {}
}

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
    local winsdk = module.Triplet.WindowsSdk.Version
    local subsystem = module.Triplet.WindowsSdk.Subsystem

    local visualstudio = module.Triplet.VisualStudio.Version

    local visualcpp = module.Triplet.VisualCpp.Version
    local platform = module.Triplet.VisualCpp.Platform

    local vsdevcmd =
        "call " ..
        "\"" ..
        module.FindFolder(visualstudio) ..
        "\\VC\\Auxiliary\\Build\\vcvarsall.bat" ..
        "\" " ..
        platform .. " " ..
        subsystem .. " " ..
        winsdk ..
        " -vcvars_ver=" .. visualcpp
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
