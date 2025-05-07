-- Local imports
local actions = require("src.Recipes.Binaries")

-- Recipe module
local recipe = {
    Name = "Streamline",
    Vendor = "NvidiaRtx",

    Version = "2.7.30",
    Revision = "0",
    Postfix = "open",
    Modification = "ImeSense",

    Type = "Binary",

    Artifacts = {},
    Dependencies = {}
}

local sourceRecipe = require("pkg.Source.NvidiaRtx.Streamline.2_7_30")
recipe.Dependencies.Source = sourceRecipe.Artifacts.Path .. sourceRecipe.Artifacts.Patched

local package = function (config)
    local runtime = Triplet.NuGet.RuntimeID
    local format = "zip"
    local name =
        recipe.Name .. "." ..
        recipe.Modification .. "." ..
        recipe.Version .. "." ..
        runtime .. "." ..
        config .. "." ..
        format
    return name
end

recipe.Artifacts.Debug = package("Debug")
recipe.Artifacts.Release = package("Release")

actions.PrepareFolders(recipe.Vendor)

local cache = Filesystem.CurrentFolder .. "/cache/Binary/" .. recipe.Vendor .. "/"
recipe.Artifacts.Path = cache

local temp = Filesystem.CurrentFolder .. "/tmp/"
local source = temp .. "streamline"

local out = temp .. "out/"

local function MakeDebug()
    local name = recipe.Artifacts.Debug
    if Filesystem.Exists(cache .. name) then
        return
    end

    SevenZip.UnpackArchive(recipe.Dependencies.Source, source)

    local root = Filesystem.CurrentFolder
    Filesystem.ChangeDirectory(source)
    Batch.CallScript("setup.bat", { "vs2022" })
    Batch.CallScript("build.bat", { "-debug" })
    Filesystem.ChangeDirectory(root)

    CMake.Rename(source .. "/bin/x64/development", out .. "bin")
    CMake.MakeFolder(out .. "share/doc/streamline")
    CMake.Rename(out .. "bin/nis.license.txt", out .. "share/doc/streamline/nis.license.txt")
    CMake.Rename(out .. "bin/nvngx_dlss.license.txt", out .. "share/doc/streamline/nvngx_dlss.license.txt")
    CMake.Rename(out .. "bin/reflex.license.txt", out .. "share/doc/streamline/reflex.license.txt")
    Filesystem.CopyFile(source .. "/NVIDIA Nsight Perf SDK License (28Sept2022).pdf", out .. "share/doc/streamline/nsight_perf_sdk.license.pdf")
    CMake.Rename(source .. "/lib/x64", out .. "lib")
    CMake.Rename(source .. "/include", out .. "include")
    CMake.Rename(source .. "/_artifacts/shaders", out .. "share/streamline")
    for file, _ in Filesystem.IterateFolder(source .. "/shaders") do
        if Filesystem.IsFile(file) then
            print(file)
            CMake.Copy(file, out .. "share/streamline")
        end
    end

    local format = "zip"
    SevenZip.PackArchive(out, cache .. name, format)
    CMake.DeleteFolder(source)
    CMake.DeleteFolder(out)
end

local function MakeProduction()
    local name = recipe.Artifacts.Release
    if Filesystem.Exists(cache .. name) then
        return
    end

    SevenZip.UnpackArchive(recipe.Dependencies.Source, source)

    local root = Filesystem.CurrentFolder
    Filesystem.ChangeDirectory(source)
    Batch.CallScript("setup.bat", { "vs2022" })
    Batch.CallScript("build.bat", { "-production" })
    Filesystem.ChangeDirectory(root)

    CMake.DeleteFolder(source .. "/bin/x64/development")
    CMake.Rename(source .. "/bin/x64", out .. "bin")
    CMake.MakeFolder(out .. "share/doc/streamline")
    CMake.Rename(out .. "bin/nis.license.txt", out .. "share/doc/streamline/nis.license.txt")
    CMake.Rename(out .. "bin/nvngx_dlss.license.txt", out .. "share/doc/streamline/nvngx_dlss.license.txt")
    CMake.Rename(out .. "bin/reflex.license.txt", out .. "share/doc/streamline/reflex.license.txt")
    Filesystem.CopyFile(source .. "/NVIDIA Nsight Perf SDK License (28Sept2022).pdf", out .. "share/doc/streamline/nsight_perf_sdk.license.pdf")
    CMake.Rename(source .. "/lib/x64", out .. "lib")
    CMake.Rename(source .. "/include", out .. "include")
    CMake.Rename(source .. "/_artifacts/shaders", out .. "share/streamline")
    for file, _ in Filesystem.IterateFolder(source .. "/shaders") do
        if Filesystem.IsFile(file) then
            CMake.Copy(file, out .. "share/streamline")
        end
    end

    local format = "zip"
    SevenZip.PackArchive(out, cache .. name, format)
    CMake.DeleteFolder(source)
    CMake.DeleteFolder(out)
end

function recipe.Make()
    MakeDebug()
    MakeProduction()
end

if Triplet.System.Name == "Windows" and Triplet.System.Version == "10.0.19041.0" then
    recipe.Make()
end

return recipe
