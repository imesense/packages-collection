-- Common imports
local lfs = require("lfs")

-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "Filesystem"
}

function module.Exists(path)
    if lfs.attributes(path, "mode") == nil then
        return false
    end
    return true
end

function module.IsFolder(path)
    if lfs.attributes(path, "mode") ~= "folder" then
        return false
    end
    return true
end

function module.IsFile(path)
    if lfs.attributes(path, "mode") ~= "file" then
        return false
    end
    return true
end

function module.GetPathSeparator()
    local separator = package.config:sub(1, 1)
    return separator
end

module.Separator = module.GetPathSeparator()

function module.GetCurrentFolder()
    local currentFolder = lfs.currentdir()
    return currentFolder
end

function module.CreateFolder(path)
    if module.Exists(path) then
        return
    end

    local result, error = lfs.mkdir(path)
    if result then
        console.PrintColor(path .. " created", console.Colors.Green)
    end
end

function module.CopyFile(source, destination)
    local sourceFile = io.open(source, "rb")
    if not sourceFile then
        return
    end

    local destinationFile = io.open(destination, "wb")
    if not destinationFile then
        sourceFile:close()
        return
    end

    local content = sourceFile:read("*a")
    destinationFile:write(content)

    sourceFile:close()
    destinationFile:close()
end

function module.MoveFile(source, destination)
    local result, error = os.rename(source, destination)
    if not result then
        console.PrintColor("Error " .. error, console.Colors.Red)
    end
end

function module.DeleteFile(path)
    local result, error = os.remove(path)
    if not result then
        return console.PrintColor("Error " .. error, console.Colors.Red)
    end
end

module.TreeFolders = {
    "tmp",
    "cache",
    "cache/Https",
    "cache/Source",
    "bin",
    "inc",
    "lib",
    "share"
}

function module.InitializeTree()
    for _, folder in ipairs(module.TreeFolders) do
        if not module.Exists(folder) then
            module.CreateFolder(folder)
        end
    end
end

return module
