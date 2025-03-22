-- Local imports
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")

-- Current module
local module = {
    Name = "SevenZip"
}

local triplet = _G.Triplet

function module.UnpackArchive(file, destination)
    local result = console.ExecuteCommand(
        triplet.Commands.SevenZip ..
        " x ".. file ..
        " -o" .. destination
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.PackArchive(path, file)
    local rootFolder = filesystem.CurrentFolder
    filesystem.ChangeDirectory(filesystem.CurrentFolder .. filesystem.Separator .. path)

    local result = console.ExecuteCommand(
        triplet.Commands.SevenZip ..
        " a" ..
        " -tzip" ..
        " -xr!*.git/*" ..
        " ../" ..
        file ..
        " -r *"
    )
    filesystem.ChangeDirectory(rootFolder)
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

return module
