-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "Utilities"
}

function module.GetEnvironmentVariable(variable)
    local result = os.getenv(variable)
    if not result or result == "" then
        console.PrintColor("Error: " .. variable, console.Colors.Red)
        return nil
    end
    return result
end

function module.TrimString(source)
    local result = (source:match("^%s*(.-)%s*$"))
    return result
end

function module.Contains(source, substring)
    local result = string.find(source, substring) ~= nil
    return result
end

return module
