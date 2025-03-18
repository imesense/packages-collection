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
    if lfs.attributes(path, "mode") ~= "directory" then
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

module.CurrentFolder = module.GetCurrentFolder()

function module.ChangeDirectory(path)
    if not module.IsFolder(path) or not module.Exists(path) then
        return
    end

    local result, err = lfs.chdir(path)
    if not result then
        console.PrintColor("Error " .. error, console.Colors.Red)
    end
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

function module.IterateFolder(folder)
    assert(folder and folder ~= "", "Parameter is missing or empty")
    if string.sub(folder, -1) == "/" then
        folder = string.sub(folder, 1, -2)
    end

    local function YieldFolder(folder)
        for entry in lfs.dir(folder) do
            if entry ~= "." and entry ~= ".." then
                entry = folder .. "/" .. entry
                local attribute = lfs.attributes(entry)
                coroutine.yield(entry, attribute)
                if attribute.mode == "directory" then
                    YieldFolder(entry)
                end
            end
        end
    end

    return coroutine.wrap(function()
        YieldFolder(folder)
    end)
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
    if not module.Exists(source) then
        return
    end

    local result, error = os.rename(source, destination)
    if not result then
        console.PrintColor("Error " .. error, console.Colors.Red)
    end
end

function module.DeleteFile(path)
    if not module.IsFile(path) or not module.Exists(path) then
        return
    end

    local result, error = os.remove(path)
    if not result then
        console.PrintColor("Error " .. error, console.Colors.Red)
    end
end

function module.DeleteFolderOnly(path)
    if not module.IsFolder(path) or not module.Exists(path) then
        return
    end

    local result, error = lfs.rmdir(path)
    if not result then
        console.PrintColor("Error " .. error, console.Colors.Red)
    end
end

function module.DeleteFolder(path)
    if not module.IsFolder(path) or not module.Exists(path) then
        return
    end

    for file, _ in module.IterateFolder(path) do
        if module.IsFile(file) then
            module.DeleteFile(file)
        end
    end

    for folder, _ in module.IterateFolder(path) do
        if module.IsFolder(folder) then
            module.DeleteFolderOnly(folder)
        end
    end

    module.DeleteFolderOnly(path)
end

module.TreeFolders = {
    "tmp",
    "cache",
    "cache/Https",
    "cache/Source",
    "bin",
    "include",
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
