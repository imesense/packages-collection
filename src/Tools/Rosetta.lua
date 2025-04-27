-- Local imports
local mappers = require("src.Common.Mappers")
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "Shell"
}

local function RunAsPlatform(command, platform)
    local shell = "arch -" .. mappers.MapMacOSPlatform(platform) .. " "
    local result = console.ExecuteCommand(shell .. command)
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.RunAsX64(command)
    local platform = "x64"
    return RunAsPlatform(command, platform)
end

return module
