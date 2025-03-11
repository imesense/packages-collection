-- Local imports
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")

-- Current module
local module = {
    Name = "Compression"
}

function module.UnpackArchive(file, destination, silent)
    local executable = "." .. filesystem.Separator .. "bin" .. filesystem.Separator .. "7za.exe"
    local output = console.ExecuteCommand(executable .. " x ".. file .. " -o" .. destination)
    if not silent then
        console.PrintColor(output, console.Colors.Default)
    end
end

return module
