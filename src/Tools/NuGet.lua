-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "NuGet"
}

local nuget = Triplet.NuGet.Command

function module.Pack(manifest, output)
    local result = console.ExecuteCommand(
        nuget ..
        " pack " .. manifest ..
        " -OutputDirectory " .. output
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

return module
