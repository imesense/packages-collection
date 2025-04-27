-- Current module
local module = {
    Name = "Console"
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
    module.PrintColor(command, module.Colors.Default)

    local handle = io.popen(command, "r")
    if not handle then
        module.PrintColor("Error " .. command, module.Colors.Red)
        return nil
    end

    local output = handle:read("*a")
    handle:close()

    module.PrintColor(output, module.Colors.Default)

    return output
end

return module
