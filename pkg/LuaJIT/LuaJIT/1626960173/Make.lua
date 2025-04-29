-- Local imports
local actions = require("src.Recipes.Actions")

-- Recipe module
local recipe = {
    Name = "LuaJIT",
    Vendor = "LuaJIT",

    Version = "1626960173",
    Revision = "0",
    Patch = "0",
    Postfix = "open",
    Modification = "IXRay"
}

local package = {}
package.Source = function (format, original)
    local name = recipe.Name .. "."
    if not original then
        name = name .. recipe.Modification .. "."
    end
    name = name .. recipe.Version .. "." .. format
    return name
end
package.CMake = function (runtime, config, format)
    local name =
        recipe.Name .. "." ..
        recipe.Modification .. "." ..
        recipe.Version .. "." ..
        runtime .. "." ..
        config .. "." ..
        format
    return name
end
package.NuGet = function (component, runtime)
    local name =
        recipe.Modification .. "." ..
        recipe.Name .. "."
    if component then
        name = name .. component .. "."
    end
    if runtime then
        name = name .. runtime .. "."
    end
    name = name ..
        recipe.Version .. "." .. recipe.Revision .. "." .. recipe.Patch .. "-" .. recipe.Postfix ..
        ".nupkg"
    return name
end

actions.PrepareFolders(recipe.Vendor)

local cache = {}
cache.Source = Filesystem.CurrentFolder .. "/cache/Source/" .. recipe.Vendor .. "/"
cache.CMake = Filesystem.CurrentFolder .. "/cache/CMake/" .. recipe.Vendor .. "/"
cache.NuGet = Filesystem.CurrentFolder .. "/cache/NuGet/" .. recipe.Vendor .. "/"

local files = Filesystem.CurrentFolder .. "/pkg/" .. recipe.Vendor .. "/" .. recipe.Name .. "/" .. recipe.Version
local patches = files .. "/patch/"
local nuget = files .. "/nuget/"
local resources = files .. "/res/"

local temp = Filesystem.CurrentFolder .. "/tmp/"
local repository = temp .. "luajit"

local out = temp .. "out/"
local source = temp .. "luajit"
local build = source .. "/build"
local install = build .. "/install"

local function MakeSourceOriginal(name, format)
    if Filesystem.Exists(cache.Source .. name) then
        return
    end

    --local url = "https://luajit.org/git/luajit.git"
    local url = "https://github.com/LuaJIT/LuaJIT.git"
    Git.CloneRepository(url, repository)

    local hash = "dbb6c39f7c69691f6bd9a8b5d6bf7c97b3dbe268"
    Git.CreateBranch(repository, "default", hash)
    CMake.DeleteFolder(repository .. "/.git")
    SevenZip.PackArchive(repository, cache.Source .. name, format)
end

local function MakeSourcePatched(name, format)
    if Filesystem.Exists(cache.Source .. name) then
        return
    end

    Git.InitializeRepository(repository)
    Git.AddFiles(repository)
    Git.CreateCommit(repository, "Initial commit")

    Git.ApplyPatch(repository, patches .. "0001-Add-CMake-projects-for-LuaJIT.patch")
    Git.ApplyPatch(repository, patches .. "0002-Revert-Remove-Lua-5.0-compatibility-defines.patch")
    Git.ApplyPatch(repository, patches .. "0003-Enable-correct-parsing-X-Ray-specific-comments.patch")
    Git.ApplyPatch(repository, patches .. "0004-Revert-Redesign-and-harden-string-interning.patch")
    Git.ApplyPatch(repository, patches .. "0005-Apply-fix-after-revert.patch")
    Git.ApplyPatch(repository, patches .. "0006-Revert-Add-jit.security.patch")
    Git.ApplyPatch(repository, patches .. "0007-Backport-fixes-for-ARM-targets-and-Clang-compiler.patch")

    CMake.DeleteFolder(repository .. "/.git")
    SevenZip.PackArchive(repository, cache.Source .. name, format)
    CMake.DeleteFolder(repository)
end

function recipe.MakeSource()
    local format = ""
    if Triplet.System.Type == "Windows" then
        format = "zip"
    elseif Triplet.System.Type == "Linux" then
        format = "tar"
    elseif Triplet.System.Type == "Darwin" then
        format = "tar"
    end

    MakeSourceOriginal(package.Source(format, true), format)
    MakeSourcePatched(package.Source(format), format)
end

local function MakeCMakeWindows(name, config)
    if Filesystem.Exists(cache.CMake .. name) then
        return
    end

    local format = "zip"
    SevenZip.UnpackArchive(cache.Source .. package.Source(format), source)

    local projectOptions = {
        ["CMAKE_SYSTEM_VERSION"] = "\"" .. Triplet.System.Version .. "\"",
        ["LUAJIT_TARGET_ARCH"] = Triplet.System.Target.Platform,
        ["LUAJIT_ENABLE_APPLICATION"] = "ON",
        ["LUAJIT_ENABLE_INSTALL"] = "ON"
    }
    local generatorOptions = {
        ["-A"] = Triplet.CMake.Generator.Target,
        ["-T"] = "host=" .. Triplet.System.Host.Platform .. ",version=" .. Triplet.VisualCpp.Version
    }
    CMake.ConfigureProject(source, build, Triplet.CMake.Generator.Name, projectOptions, generatorOptions)
    CMake.BuildProject(build, config)
    CMake.InstallProject(build, install, config)

    CMake.Rename(install, out .. "/" .. config)
    CMake.DeleteFolder(source)
    SevenZip.PackArchive(out .. "/" .. config, cache.CMake .. name, format)
    CMake.DeleteFolder(out)
end

local function MakeCMakeLinux(name, config)
    if Filesystem.Exists(cache.CMake .. name) then
        return
    end

    local format = "tar"
    SevenZip.UnpackArchive(cache.Source .. package.Source(format), source)

    local projectOptions = {
        ["LUAJIT_TARGET_ARCH"] = Triplet.System.Target.Platform,
        ["LUAJIT_ENABLE_APPLICATION"] = "ON",
        ["LUAJIT_ENABLE_INSTALL"] = "ON",
        ["CMAKE_C_COMPILER"] = Triplet.CMake.C.Compiler
    }
    CMake.ConfigureProject(source, build, Triplet.CMake.Generator.Name, projectOptions)
    CMake.BuildProject(build, config)
    CMake.InstallProject(build, install, config)

    CMake.Rename(install, out .. "/" .. config)
    CMake.DeleteFolder(source)
    SevenZip.PackArchive(out .. "/" .. config, cache.CMake .. name, format)
    CMake.DeleteFolder(out)
end

local function MakeCMakeDarwin(name, config)
    if Filesystem.Exists(cache.CMake .. name) then
        return
    end

    local format = "tar"
    SevenZip.UnpackArchive(cache.Source .. package.Source(format), source)

    local projectOptions = {
        ["LUAJIT_TARGET_ARCH"] = Triplet.System.Target.Platform,
        ["LUAJIT_ENABLE_APPLICATION"] = "ON",
        ["LUAJIT_ENABLE_INSTALL"] = "ON",
        ["CMAKE_OSX_DEPLOYMENT_TARGET"] = Triplet.System.Version
    }
    CMake.ConfigureProject(source, build, Triplet.CMake.Generator.Name, projectOptions)
    CMake.BuildProject(build, config)
    CMake.InstallProject(build, install, config)

    CMake.Rename(install, out .. "/" .. config)
    CMake.DeleteFolder(source)
    SevenZip.PackArchive(out .. "/" .. config, cache.CMake .. name, format)
    CMake.DeleteFolder(out)
end

function recipe.MakeCMake(config)
    local runtime = Triplet.NuGet.RuntimeID
    if Triplet.System.Type == "Windows" then
        MakeCMakeWindows(package.CMake(runtime, config, "zip"), config)
    elseif Triplet.System.Type == "Linux" then
        MakeCMakeLinux(package.CMake(runtime, config, "tar"), config)
    elseif Triplet.System.Type == "Darwin" then
        MakeCMakeDarwin(package.CMake(runtime, config, "tar"), config)
    end
end

local function MakeNuGetMetapackage(output, manifest)
    if Filesystem.Exists(cache.NuGet .. output) then
        return
    end

    CMake.Copy(nuget .. manifest .. ".nuspec", out)
    CMake.Copy(resources .. "README.md", out)
    CMake.Copy(resources .. "LICENSE.txt", out)
    NuGet.Pack(out .. manifest .. ".nuspec", cache.NuGet)
    CMake.DeleteFolder(out)
end

local function MakeNuGetSources(output, manifest, input)
    if Filesystem.Exists(cache.NuGet .. output) then
        return
    end

    SevenZip.UnpackArchive(cache.Source .. input, out)
    CMake.Copy(nuget .. manifest .. ".nuspec", out)
    CMake.Copy(resources .. "README.md", out)
    CMake.Copy(resources .. "LICENSE.txt", out)
    CMake.Rename(out .. "README", out .. "README.orig")
    CMake.Rename(out .. "COPYRIGHT", out .. "COPYRIGHT.orig")
    NuGet.Pack(out .. manifest .. ".nuspec", cache.NuGet)
    CMake.DeleteFolder(out)
end

local function MakeNuGetBinaries(name, manifest, input)
    if Filesystem.Exists(cache.NuGet .. name) then
        return
    end

    SevenZip.UnpackArchive(cache.CMake .. input, out)
    CMake.Copy(nuget .. manifest .. ".nuspec", out)
    CMake.Copy(resources .. "README.md", out)
    CMake.Copy(resources .. "LICENSE.txt", out)
    NuGet.Pack(out .. manifest .. ".nuspec", cache.NuGet)
    CMake.DeleteFolder(out)
end

function recipe.MakeNuGet(component, runtime)
    local input = ""
    local output = ""

    local manifest = component
    if runtime then
        manifest = manifest .. "." .. runtime
    end

    if component == "metapackage" then
        output = package.NuGet()
        MakeNuGetMetapackage(output, manifest)
    elseif component == "binaries" and not runtime then
        output = package.NuGet("Binaries")
        MakeNuGetMetapackage(output, manifest)
    elseif component == "symbols" and not runtime then
        output = package.NuGet("Symbols")
        MakeNuGetMetapackage(output, manifest)
    elseif component == "sources" then
        output = package.NuGet("Sources")
        input = package.Source("zip")
        MakeNuGetSources(output, manifest, input)
    elseif component == "binaries" and runtime then
        output = package.NuGet("Binaries", runtime)

        local format = ""
        if Utilities.Contains(runtime, "win") then
            format = "zip"
        elseif Utilities.Contains(runtime, "ubuntu") then
            format = "tar"
        elseif Utilities.Contains(runtime, "osx") then
            format = "tar"
        end

        local config = ""
        if Utilities.Contains(runtime, "win") then
            config = "Release"
        elseif Utilities.Contains(runtime, "ubuntu") then
            config = "Release"
        elseif Utilities.Contains(runtime, "osx") then
            config = "RelWithDebInfo"
        end

        input = package.CMake(runtime, config, format)
        MakeNuGetBinaries(output, manifest, input)
    elseif component == "symbols" and runtime then
        output = package.NuGet("Symbols", runtime)

        local format = ""
        if Utilities.Contains(runtime, "win") then
            format = "zip"
        elseif Utilities.Contains(runtime, "ubuntu") then
            format = "tar"
        elseif Utilities.Contains(runtime, "osx") then
            format = "tar"
        end

        local config = ""
        if Utilities.Contains(runtime, "win") then
            config = "Release"
        elseif Utilities.Contains(runtime, "ubuntu") then
            config = "Release"
        elseif Utilities.Contains(runtime, "osx") then
            config = "RelWithDebInfo"
        end

        input = package.CMake(runtime, config, format)
        MakeNuGetBinaries(output, manifest, input)
    end
end

if Options.Target == "source" then
    recipe.MakeSource()
elseif Options.Target == "cmake" then
    recipe.MakeCMake(Options.Argument)
elseif Options.Target == "nuget" then
    recipe.MakeNuGet(Options.Argument, Options.Argument1)
end

return recipe
