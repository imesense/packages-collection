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

return module
