-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "Batch"
}

function module.CallScript(path, arguments)
    local command = "call " .. path .. ""
    for _, argument in ipairs(arguments) do
        command = command .. " " .. argument
    end

    local result = console.ExecuteCommand(command)
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.RenameFile(source, destination)
    local command = "ren " .. source .. " " .. destination

    local result = console.ExecuteCommand(command)
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

return module
