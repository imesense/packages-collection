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

function module.GetTimestamp(date)
    local year, month, day, hour, min, sec =
        date:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)
    hour = tonumber(hour)
    min = tonumber(min)
    sec = tonumber(sec)

    local timestamp = os.time({
        ---@diagnostic disable-next-line: assign-type-mismatch
        year = year,
        ---@diagnostic disable-next-line: assign-type-mismatch
        month = month,
        ---@diagnostic disable-next-line: assign-type-mismatch
        day = day,
        hour = hour,
        min = min,
        sec = sec
    })
    return timestamp
end

return module
