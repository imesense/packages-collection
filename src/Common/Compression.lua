-- Local imports
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")

-- Current module
local module = {
    Name = "Compression"
}

function module.UnpackArchive(file, destination)
    local command = "." .. filesystem.Separator .. "bin" .. filesystem.Separator .. "7za.exe"
    console.ExecuteCommand(command .. " x ".. file .. " -o" .. destination)
end

function module.PackArchive(path, file)
    local rootFolder = filesystem.CurrentFolder
    filesystem.ChangeDirectory(filesystem.CurrentFolder .. "/" .. path)

    local command = rootFolder .. "/" .. filesystem.Separator .. "bin" .. filesystem.Separator .. "7za.exe"
    console.ExecuteCommand(command .. " a -tzip -xr!*.git/* ../" .. file .. " -r *")
    filesystem.ChangeDirectory(rootFolder)
end

return module
