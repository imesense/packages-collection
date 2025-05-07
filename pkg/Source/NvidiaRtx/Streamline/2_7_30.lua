-- Local imports
local actions = require("src.Recipes.Sources")

-- Recipe module
local recipe = {
    Name = "Streamline",
    Vendor = "NvidiaRtx",

    Version = "2.7.30",
    Revision = "0",
    Postfix = "open",
    Modification = "ImeSense",

    Type = "Source",

    Artifacts = {}
}

local package = function (original)
    local name = recipe.Name .. "."
    if not original then
        name = name .. recipe.Modification .. "."
    end

    local format = "zip"
    name = name .. recipe.Version .. "." .. format
    return name
end

recipe.Artifacts.Original = package(true)
recipe.Artifacts.Patched = package(false)

actions.PrepareFolders(recipe.Vendor)

local cache = Filesystem.CurrentFolder .. "/cache/Source/" .. recipe.Vendor .. "/"
recipe.Artifacts.Path = cache

local patches = Filesystem.CurrentFolder .. "/patch/" .. recipe.Vendor .. "/" .. recipe.Name .. "/" .. recipe.Version .. "/"

local temp = Filesystem.CurrentFolder .. "/tmp/"
local repository = temp .. "streamline"

local function MakeOriginal()
    local name = recipe.Artifacts.Original
    if Filesystem.Exists(cache .. name) then
        return
    end

    local url = "https://github.com/NVIDIA-RTX/Streamline.git"
    local branch = "v2.7.30"
    Git.CloneRepositoryBranch(url, repository, branch)

    CMake.DeleteFolder(repository .. "/.git")

    local format = "zip"
    SevenZip.PackArchive(repository, cache .. name, format)
end

local function MakePatched()
    local name = recipe.Artifacts.Patched
    if Filesystem.Exists(cache .. name) then
        return
    end

    Git.InitializeRepository(repository)
    Git.AddFiles(repository)
    Git.CreateCommit(repository, "Initial commit")

    Git.ApplyPatch(repository, patches .. "0001-Add-missing-chrono-header.patch")

    CMake.DeleteFolder(repository .. "/.git")

    local format = "zip"
    SevenZip.PackArchive(repository, cache .. name, format)
    CMake.DeleteFolder(repository)
end

function recipe.Make()
    MakeOriginal()
    MakePatched()
end

if Triplet.System.Name == "Windows" and Triplet.System.Version == "10.0.19041.0" then
    recipe.Make()
end

return recipe
