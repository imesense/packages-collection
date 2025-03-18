-- Local imports
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")
local utilities = require("src.Common.Utilities")

-- Current module
local module = {
    Name = "BuildSystem"
}

function module.FindVisualStudio(version)
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

function module.RunVisualStudio(command)
    local visualstudio = "17"
    local platform = "amd64"
    local subsystem = ""
    local winsdk = "10.0.19041.0"
    local visualcpp = "14.43"
    local vsdevcmd =
        "call \"" .. module.FindVisualStudio(visualstudio) .. "\\VC\\Auxiliary\\Build\\vcvarsall.bat" .. "\" " ..
        platform ..
        subsystem .. " " ..
        winsdk ..
        " -vcvars_ver=" .. visualcpp

    local result = console.ExecuteCommand(vsdevcmd .. " && " .. utilities.TrimString(command))
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.RunCMakeConfigure(source, build, generator, projectOptions, generatorOptions)
    local command =
        "cmake" ..
        " -S " .. source ..
        " -B " .. build ..
        " -G \"" .. generator .. "\""

    local options1 = ""
    if generatorOptions and generatorOptions ~= "" then
        for key, value in pairs(generatorOptions) do
            if key == "-T" then
                value = "\"" .. value .. "\""
            end
            options1 = options1 .. " " .. key .. " " .. value
        end
        command = command .. options1
    end

    local options2 = ""
    if projectOptions and projectOptions ~= "" then
        for key, value in pairs(projectOptions) do
            options2 = options2 .. " -D" .. key .. "=" .. value
        end
        command = command .. options2
    end

    local result = module.RunVisualStudio(command)
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.RunCMakeBuild(build, config)
    local command =
        "cmake" ..
        " --build " .. build
    if config and config ~= "" then
        command = command .. " --config " .. config
    end

    local result = module.RunVisualStudio(command)
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.RunCMakeInstall(build, config, prefix)
    local command =
        "cmake" ..
        " --install " .. build
    if config and config ~= "" then
        command = command .. " --config " .. config
    end
    if prefix and prefix ~= "" then
        command = command .. " --prefix " .. prefix
    end

    local result = module.RunVisualStudio(command)
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

return module
