-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "CMake"
}

local cmake = Triplet.CMake.Command

local function InvokeShell(command)
    local shell = console.ExecuteCommand
    if Triplet.System.Type == "Windows" then
        local visualStudio = require("src.Tools.VisualStudio")
        shell = visualStudio.RunDevCmd
    elseif Triplet.System.Type == "Darwin" then
        local rosetta = require("src.Tools.Rosetta")
        shell = rosetta.RunAsX64
    end

    local result = shell(command)
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.ConfigureProject(source, build, generator, projectOptions, generatorOptions)
    local command =
        cmake ..
        " -S " .. source ..
        " -B " .. build ..
        " -G \"" .. generator .. "\""

    local options1 = ""
    if generatorOptions and generatorOptions ~= "" then
        for key, value in pairs(generatorOptions) do
            if key == "-A" then
                value = "\"" .. value .. "\""
            end
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

    return InvokeShell(command)
end

function module.BuildProject(build, config)
    local command =
        cmake ..
        " --build " .. build
    if config and config ~= "" then
        command = command .. " --config " .. config
    end
    return InvokeShell(command)
end

function module.InstallProject(build, prefix, config)
    local command =
        cmake ..
        " --install " .. build
    if config and config ~= "" then
        command = command .. " --config " .. config
    end
    if prefix and prefix ~= "" then
        command = command .. " --prefix " .. prefix
    end
    return InvokeShell(command)
end

function module.DeleteFolder(path)
    local result = console.ExecuteCommand(
        cmake ..
        " -E" ..
        " remove_directory " ..
        path
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.Rename(source, destination)
    local result = console.ExecuteCommand(
        cmake ..
        " -E" ..
        " rename " ..
        source .. " " ..
        destination
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.Copy(source, destination)
    local result = console.ExecuteCommand(
        cmake ..
        " -E" ..
        " copy " ..
        source .. " " ..
        destination
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

return module
