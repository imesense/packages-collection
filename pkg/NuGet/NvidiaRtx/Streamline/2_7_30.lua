-- Local imports
local actions = require("src.Recipes.NuGet")

-- Recipe module
local recipe = {
    Name = "Streamline",
    Vendor = "NvidiaRtx",

    Version = "2.7.30",
    Revision = "0",
    Postfix = "open",
    Modification = "ImeSense",

    Type = "NuGet",

    Artifacts = {},
    Dependencies = {}
}

local binaryRecipe = require("pkg.Binary.NvidiaRtx.Streamline.2_7_30")
recipe.Dependencies.Binary = binaryRecipe.Artifacts.Path .. binaryRecipe.Artifacts.Release
local sourceRecipe = require("pkg.Source.NvidiaRtx.Streamline.2_7_30")
recipe.Dependencies.Source = sourceRecipe.Artifacts.Path .. sourceRecipe.Artifacts.Patched

local package = function (component, runtime)
    local name =
        recipe.Modification .. "." ..
        recipe.Name .. "."
    if component then
        name = name .. component .. "."
    end
    if runtime then
        name = name .. runtime .. "."
    end
    name =
        name ..
        recipe.Version ..
        ".nupkg"
    return name
end

recipe.Artifacts.Metapackage = package(nil, nil)
recipe.Artifacts.Binaries = package("Binaries", nil)
recipe.Artifacts.BinariesWin10 = package("Binaries", Triplet.NuGet.RuntimeID)
recipe.Artifacts.Sources = package("Sources", nil)

actions.PrepareFolders(recipe.Vendor)

local cache = Filesystem.CurrentFolder .. "/cache/NuGet/" .. recipe.Vendor .. "/"

local resources = Filesystem.CurrentFolder .. "/res/" .. recipe.Vendor .. "/" .. recipe.Name .. "/" .. recipe.Version .. "/"

local temp = Filesystem.CurrentFolder .. "/tmp/"
local out = temp .. "out/"

local function MakeMetapackage(output, manifest)
    if Filesystem.Exists(cache .. output) then
        return
    end

    CMake.MakeFolder(out)
    CMake.Copy(resources .. manifest .. ".nuspec", out)
    CMake.Copy(resources .. "README.md", out)
    CMake.Copy(resources .. "LICENSE.txt", out)
    NuGet.Pack(out .. manifest .. ".nuspec", cache)
    CMake.DeleteFolder(out)
end

local function MakeSources(output, manifest)
    if Filesystem.Exists(cache .. output) then
        return
    end

    CMake.MakeFolder(out)
    SevenZip.UnpackArchive(recipe.Dependencies.Binary, out)
    CMake.Rename(out .. "share/doc/streamline", out .. "doc")
    CMake.DeleteFolder(out .. "bin")
    CMake.DeleteFolder(out .. "include")
    CMake.DeleteFolder(out .. "lib")

    SevenZip.UnpackArchive(recipe.Dependencies.Source, out)
    CMake.Rename(out .. "README.md", out .. "README.md.orig")
    CMake.Rename(out .. "license.txt", out .. "LICENSE.txt.orig")
    CMake.Copy(resources .. manifest .. ".nuspec", out)
    CMake.Copy(resources .. "README.md", out)
    CMake.Copy(resources .. "LICENSE.txt", out)
    NuGet.Pack(out .. manifest .. ".nuspec", cache)
    CMake.DeleteFolder(out)
end

local function MakeBinaries(output, manifest)
    if Filesystem.Exists(cache .. output) then
        return
    end

    CMake.MakeFolder(out)
    SevenZip.UnpackArchive(recipe.Dependencies.Binary, out)
    CMake.Copy(resources .. manifest .. ".nuspec", out)
    CMake.Copy(resources .. "README.md", out)
    CMake.Copy(resources .. "LICENSE.txt", out)
    NuGet.Pack(out .. manifest .. ".nuspec", cache)
    CMake.DeleteFolder(out)
end

function recipe.Make()
    MakeMetapackage(recipe.Artifacts.Metapackage, "metapackage")
    MakeMetapackage(recipe.Artifacts.Binaries, "binaries")
    MakeBinaries(recipe.Artifacts.BinariesWin10, "binaries." .. Triplet.NuGet.RuntimeID)
    MakeSources(recipe.Artifacts.Sources, "sources")
end

if Triplet.System.Name == "Windows" and Triplet.System.Version == "10.0.19041.0" then
    recipe.Make()
end

return recipe
