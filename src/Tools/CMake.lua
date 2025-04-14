-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "CMake",
    Triplet = {},
    Shell = nil
}

function module.InvokeShell(command)
    local result = module.Shell(command)
    console.PrintColor(result, console.Colors.Default)
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.ConfigureProject(source, build, generator, projectOptions, generatorOptions)
    local command =
        module.Triplet.Commands.CMake ..
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

    console.PrintColor(command, console.Colors.Default)

    return module.InvokeShell(command)
end

function module.BuildProject(build, config)
    local command =
        module.Triplet.Commands.CMake ..
        " --build " .. build
    if config and config ~= "" then
        command = command .. " --config " .. config
    end
    console.PrintColor(command, console.Colors.Default)
    return module.InvokeShell(command)
end

function module.InstallProject(build, prefix, config)
    local command =
        module.Triplet.Commands.CMake ..
        " --install " .. build
    if config and config ~= "" then
        command = command .. " --config " .. config
    end
    if prefix and prefix ~= "" then
        command = command .. " --prefix " .. prefix
    end
    console.PrintColor(command, console.Colors.Default)
    return module.InvokeShell(command)
end

function module.DeleteFolder(path)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.CMake ..
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
        module.Triplet.Commands.CMake ..
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
        module.Triplet.Commands.CMake ..
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
