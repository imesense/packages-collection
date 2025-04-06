-- Local imports
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")

-- Current module
local module = {
    Name = "SevenZip",
    Triplet = {}
}

function module.UnpackArchive(file, destination)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.SevenZip ..
        " x ".. file ..
        " -o" .. destination
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.PackArchive(path, file, format)
    local rootFolder = filesystem.CurrentFolder
    filesystem.ChangeDirectory(path)

    local result = console.ExecuteCommand(
        module.Triplet.Commands.SevenZip ..
        " a" ..
        " -t" .. format ..
        " " .. file ..
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
