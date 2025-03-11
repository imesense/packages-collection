-- Common imports
local https = require("ssl.https")

-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "Network"
}

local function DownloadFileHttps(url, path)
    local response = {}
    local result, statusCode, headers, statusLine = https.request({
        url = url,
        sink = ltn12.sink.table(response)
    })
    if result then
        local file = io.open(path, "wb")
        if file then
            file:write(table.concat(response))
            file:close()
        else
            console.PrintColor("Error " .. path, console.Colors.Red)
        end
    else
        console.PrintColor("Error " .. statusCode, console.Colors.Red)
    end
end

function module.DownloadFile(url, path)
    if string.match(url, "^https://") then
        DownloadFileHttps(url, path)
    end
end

return module
