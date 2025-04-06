-- Current module
local module = {
    Name = "Console",

    Parameters = {
        EnableCommandsOutput = false
    }
}

-- Text colors
module.Colors = {
    Default = "\27[0m",
    Red = "\27[31m",
    Green = "\27[32m",
    Yellow = "\27[33m"
}

function module.PrintColor(text, color)
    print(color .. text .. module.Colors.Default)
end

function module.ExecuteCommand(command)
    local handle = io.popen(command)
    if not handle then
        module.PrintColor("Error " .. command, module.Colors.Red)
        return nil
    end

    local output = handle:read("*a")
    handle:close()

    if module.Parameters.EnableCommandsOutput then
        module.PrintColor(output, module.Colors.Default)
    end

    return output
end

function module.ParseArguments()
    local options = {
        Triplet = nil,
        Target = nil,
        TargetArgument = nil
    }

    local scriptArguments = arg
    for _, scriptArgument in ipairs(scriptArguments) do
        local key, value = scriptArgument:match("^%-%-(%w+)=(.*)$")
        if key then
            if key == "triplet" then
                options.Triplet = value
            elseif key == "target" then
                options.Target = value
            elseif key == "targetarg" then
                options.TargetArgument = value
            else
                io.stderr:write(module.Colors.Yellow .. "Warning: Unknown option \"--" .. key .. "\"\n" .. module.Colors.Default)
            end
        else
            io.stderr:write(module.Colors.Yellow .. "Warning: Invalid argument format \"" .. arg .. "\". Expected --key=value\n" .. module.Colors.Default)
        end
    end

    if not options.Triplet then
        io.stderr:write(module.Colors.Red .. "Error: --triplet is required\n" .. module.Colors.Default)
        os.exit(1)
    end
    if not options.Target then
        io.stderr:write(module.Colors.Red .. "Error: --target is required\n" .. module.Colors.Default)
        os.exit(1)
    end

    return options
end

return module
