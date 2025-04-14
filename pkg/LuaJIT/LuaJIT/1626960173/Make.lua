-- Local imports
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")
local git = require("src.Tools.Git")
local sevenZip = require("src.Tools.SevenZip")
local cmake = require("src.Tools.CMake")
local visualStudio = require("src.Tools.VisualStudio")
local nuget = require("src.Tools.NuGet")

-- Arguments and triplets
local options = console.ParseArguments()
local triplet = require("src.Triplets." .. options.Triplet)
git.Triplet = triplet
cmake.Triplet = triplet
sevenZip.Triplet = triplet
nuget.Triplet = triplet
cmake.Shell = console.ExecuteCommand

if triplet.System.Name == "Windows" then
    visualStudio.Triplet = triplet
    sevenZip.Triplet.Commands.SevenZip = filesystem.CurrentFolder .. triplet.Commands.SevenZip
    cmake.Shell = visualStudio.RunDevCmd
end

-- Recipe module
local recipe = {
    Name = "LuaJIT",
    Vendor = "LuaJIT",

    Version = "1626960173",
    Revision = "0",
    Modification = "IXRay"
}

function recipe.CreateFolders()
    filesystem.InitializeTree()

    local folders = {
        "cache/Source/" .. recipe.Vendor,
        "cache/CMake/" .. recipe.Vendor,
        "cache/NuGet/" .. recipe.Vendor
    }
    for _, path in ipairs(folders) do
        filesystem.CreateFolder(path)
    end
end

function recipe.MakeSource()
    recipe.CreateFolders()

    console.PrintColor("Making source packages ...", console.Colors.Default)

    local format = ""
    if triplet.System.Name == "Windows" then
        format = "zip"
    else
        format = "tar"
    end

    local cache = filesystem.CurrentFolder .. "/cache/Source/" .. recipe.Vendor .. "/"
    local temp = filesystem.CurrentFolder .. "/tmp/"
    local repository = temp .. "luajit"

    local packageOriginal =
        recipe.Vendor .. "." .. recipe.Name .. "." ..
        recipe.Version .. "." .. format
    if not filesystem.Exists(cache .. packageOriginal) then
        local url = "https://luajit.org/git/luajit.git"
        git.CloneRepository(url, repository)

        local hash = "dbb6c39f7c69691f6bd9a8b5d6bf7c97b3dbe268"
        git.CreateBranch(repository, "default", hash)
        cmake.DeleteFolder(repository .. "/.git")
        sevenZip.PackArchive(repository, cache .. packageOriginal, format)
    end

    local packagePatched =
        recipe.Vendor .. "." .. recipe.Name .. "." ..
        recipe.Modification .. "." .. recipe.Version .. "." .. format
    if not filesystem.Exists(cache .. packagePatched) then
        local patches = filesystem.CurrentFolder .. "/pkg/" .. recipe.Vendor .. "/" .. recipe.Name .. "/" .. recipe.Version .. "/patch/"
        git.InitializeRepository(repository)
        git.AddFiles(repository)
        git.CreateCommit(repository, "Initial commit")

        git.ApplyPatch(repository, patches .. "0001-Add-CMake-projects-for-LuaJIT.patch")
        git.ApplyPatch(repository, patches .. "0002-Revert-Remove-Lua-5.0-compatibility-defines.patch")
        git.ApplyPatch(repository, patches .. "0003-Enable-correct-parsing-X-Ray-specific-comments.patch")
        git.ApplyPatch(repository, patches .. "0004-Revert-Redesign-and-harden-string-interning.patch")
        git.ApplyPatch(repository, patches .. "0005-Apply-fix-after-revert.patch")
        git.ApplyPatch(repository, patches .. "0006-Revert-Add-jit.security.patch")
        git.ApplyPatch(repository, patches .. "0007-Backport-fixes-for-ARM-targets-and-Clang-compiler.patch")

        cmake.DeleteFolder(repository .. "/.git")
        sevenZip.PackArchive(repository, cache .. packagePatched, format)
        cmake.DeleteFolder(repository)
    end

    console.PrintColor("Making source packages done", console.Colors.Green)
end

function recipe.MakeCMake()
    recipe.CreateFolders()

    console.PrintColor("Making CMake packages ...", console.Colors.Default)

    local format = ""
    if triplet.System.Name == "Windows" then
        format = "zip"
    else
        format = "tar"
    end

    local sourceCache = filesystem.CurrentFolder .. "/cache/Source/" .. recipe.Vendor .. "/"
    local binaryCache = filesystem.CurrentFolder .. "/cache/CMake/" .. recipe.Vendor .. "/"

    local temp = "tmp/"
    local out = temp .. "/out"
    local source = temp .. "luajit"
    local build = source .. "/build"
    local install = build .. "/install"

    local debug = "Debug"
    local release = "Release"

    local sourcePackage =
        recipe.Vendor .. "." .. recipe.Name .. "." ..
        recipe.Modification .. "." .. recipe.Version .. "." .. format

    local binaryPackageDebug =
        recipe.Vendor .. "." .. recipe.Name .. "." ..
        recipe.Modification .. "." .. recipe.Version .. "." ..
        triplet.RuntimeID .. "." .. debug .. "." ..
        format
    local binaryPackageRelease =
        recipe.Vendor .. "." .. recipe.Name .. "." ..
        recipe.Modification .. "." .. recipe.Version .. "." ..
        triplet.RuntimeID .. "." .. release .. "." ..
        format

    if not filesystem.Exists(binaryCache .. binaryPackageDebug)
    and not filesystem.Exists(binaryCache .. binaryPackageRelease) then
        sevenZip.UnpackArchive(sourceCache .. sourcePackage, filesystem.CurrentFolder .. "/" .. source)

        if triplet.System.Name == "Windows"
        and triplet.System.Platform == "x64" then
            -- Set options
            local projectOptions = {
                ["CMAKE_SYSTEM_VERSION"] = "\"" .. triplet.WindowsSdk.Version .. "\"",
                ["LUAJIT_TARGET_ARCH"] = triplet.System.Platform,
                ["LUAJIT_ENABLE_APPLICATION"] = "ON",
                ["LUAJIT_ENABLE_INSTALL"] = "ON"
            }
            local generatorOptions = {
                ["-A"] = triplet.System.Platform,
                ["-T"] = "host=" .. triplet.System.Platform .. ",version=" .. triplet.VisualCpp.Version
            }

            -- Build debug package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions, generatorOptions)
            cmake.BuildProject(build, debug)
            cmake.InstallProject(build, install .. "/" .. debug, debug)
            cmake.Rename(install .. "/" .. debug, out .. "/" .. debug)
            cmake.DeleteFolder(build)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. debug, binaryCache .. binaryPackageDebug, format)

            -- Build release package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions, generatorOptions)
            cmake.BuildProject(build, release)
            cmake.InstallProject(build, install .. "/" .. release, release)
            cmake.Rename(install .. "/" .. release, out .. "/" .. release)
            cmake.DeleteFolder(source)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. release, binaryCache .. binaryPackageRelease, format)
            cmake.DeleteFolder(out)
        elseif triplet.System.Name == "Windows"
        and triplet.System.Platform == "x86" then
            -- Set options
            local projectOptions = {
                ["CMAKE_SYSTEM_VERSION"] = "\"" .. triplet.WindowsSdk.Version .. "\"",
                ["LUAJIT_TARGET_ARCH"] = triplet.System.Platform,
                ["LUAJIT_ENABLE_APPLICATION"] = "ON",
                ["LUAJIT_ENABLE_INSTALL"] = "ON"
            }
            local generatorOptions = {
                ["-A"] = "Win32",
                ["-T"] = "host=x64,version=" .. triplet.VisualCpp.Version
            }

            -- Build debug package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions, generatorOptions)
            cmake.BuildProject(build, debug)
            cmake.InstallProject(build, install .. "/" .. debug, debug)
            cmake.Rename(install .. "/" .. debug, out .. "/" .. debug)
            cmake.DeleteFolder(build)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. debug, binaryCache .. binaryPackageDebug, format)

            -- Build release package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions, generatorOptions)
            cmake.BuildProject(build, release)
            cmake.InstallProject(build, install .. "/" .. release, release)
            cmake.Rename(install .. "/" .. release, out .. "/" .. release)
            cmake.DeleteFolder(source)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. release, binaryCache .. binaryPackageRelease, format)
            cmake.DeleteFolder(out)
        elseif triplet.System.Name == "Ubuntu"
        and triplet.System.Platform == "x86" then
            -- Set options
            local projectOptions = {
                ["LUAJIT_TARGET_ARCH"] = "x86",
                ["LUAJIT_ENABLE_APPLICATION"] = "ON",
                ["LUAJIT_ENABLE_INSTALL"] = "ON",
                ["CMAKE_C_COMPILER"] = triplet.Compiler
            }

            -- Build debug package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions)
            cmake.BuildProject(build, debug)
            cmake.InstallProject(build, install .. "/" .. debug, debug)
            cmake.Rename(install .. "/" .. debug, out .. "/" .. debug)
            cmake.DeleteFolder(build)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. debug, binaryCache .. binaryPackageDebug, format)

            -- Build release package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions)
            cmake.BuildProject(build, release)
            cmake.InstallProject(build, install .. "/" .. release, release)
            cmake.Rename(install .. "/" .. release, out .. "/" .. release)
            cmake.DeleteFolder(source)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. release, binaryCache .. binaryPackageRelease, format)
            cmake.DeleteFolder(out)
        elseif triplet.System.Name == "Ubuntu"
        and triplet.System.Platform == "x64" then
            -- Set options
            local projectOptions = {
                ["LUAJIT_TARGET_ARCH"] = "x64",
                ["LUAJIT_ENABLE_APPLICATION"] = "ON",
                ["LUAJIT_ENABLE_INSTALL"] = "ON",
                ["CMAKE_C_COMPILER"] = triplet.Compiler
            }

            -- Build debug package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions)
            cmake.BuildProject(build, debug)
            cmake.InstallProject(build, install .. "/" .. debug, debug)
            cmake.Rename(install .. "/" .. debug, out .. "/" .. debug)
            cmake.DeleteFolder(build)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. debug, binaryCache .. binaryPackageDebug, format)

            -- Build release package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions)
            cmake.BuildProject(build, release)
            cmake.InstallProject(build, install .. "/" .. release, release)
            cmake.Rename(install .. "/" .. release, out .. "/" .. release)
            cmake.DeleteFolder(source)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. release, binaryCache .. binaryPackageRelease, format)
            cmake.DeleteFolder(out)
        elseif triplet.System.Name == "Ubuntu"
        and triplet.System.Platform == "arm64" then
            -- Set options
            local projectOptions = {
                ["LUAJIT_TARGET_ARCH"] = "arm64",
                ["LUAJIT_ENABLE_APPLICATION"] = "ON",
                ["LUAJIT_ENABLE_INSTALL"] = "ON",
                ["CMAKE_C_COMPILER"] = triplet.Compiler
            }

            -- Build debug package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions)
            cmake.BuildProject(build, debug)
            cmake.InstallProject(build, install .. "/" .. debug, debug)
            cmake.Rename(install .. "/" .. debug, out .. "/" .. debug)
            cmake.DeleteFolder(build)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. debug, binaryCache .. binaryPackageDebug, format)

            -- Build release package
            cmake.ConfigureProject(source, build, triplet.CMakeGenerator, projectOptions)
            cmake.BuildProject(build, release)
            cmake.InstallProject(build, install .. "/" .. release, release)
            cmake.Rename(install .. "/" .. release, out .. "/" .. release)
            cmake.DeleteFolder(source)
            sevenZip.PackArchive(filesystem.CurrentFolder .. "/" .. out .. "/" .. release, binaryCache .. binaryPackageRelease, format)
            cmake.DeleteFolder(out)
        end
    end

    console.PrintColor("Making CMake packages done", console.Colors.Green)
end

function recipe.MakeNuGet(component)
    recipe.CreateFolders()

    console.PrintColor("Making NuGet package ...", console.Colors.Default)

    local sourceCache = filesystem.CurrentFolder .. "/cache/Source/" .. recipe.Vendor .. "/"
    local binaryCache = filesystem.CurrentFolder .. "/cache/CMake/" .. recipe.Vendor .. "/"
    local nugetCache = filesystem.CurrentFolder .. "/cache/NuGet/" .. recipe.Vendor .. "/"

    local files = filesystem.CurrentFolder .. "/pkg/" .. recipe.Vendor .. "/" .. recipe.Name .. "/" .. recipe.Version

    local temp = "tmp/"
    local out = temp .. "/out/"

    local metapackage = recipe.Modification .. "." .. recipe.Name .. "." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local sources = recipe.Modification .. "." .. recipe.Name .. ".Sources." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"

    local runtimesWinX86 = recipe.Modification .. "." .. recipe.Name .. ".Binaries.win10.0.19041.0-x86." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local runtimesWinX64 = recipe.Modification .. "." .. recipe.Name .. ".Binaries.win10.0.19041.0-x64." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local symbolsWinX86 = recipe.Modification .. "." .. recipe.Name .. ".Symbols.win10.0.19041.0-x86." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local symbolsWinX64 = recipe.Modification .. "." .. recipe.Name .. ".Symbols.win10.0.19041.0-x64." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"

    local runtimesUbuntu2004X86 = recipe.Modification .. "." .. recipe.Name .. ".Binaries.ubuntu.20.04-x86." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local runtimesUbuntu2004X64 = recipe.Modification .. "." .. recipe.Name .. ".Binaries.ubuntu.20.04-x64." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local runtimesUbuntu2004Arm64 = recipe.Modification .. "." .. recipe.Name .. ".Binaries.ubuntu.20.04-arm64." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local symbolsUbuntu2004X86 = recipe.Modification .. "." .. recipe.Name .. ".Symbols.ubuntu.20.04-x86." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local symbolsUbuntu2004X64 = recipe.Modification .. "." .. recipe.Name .. ".Symbols.ubuntu.20.04-x64." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"
    local symbolsUbuntu2004Arm64 = recipe.Modification .. "." .. recipe.Name .. ".Symbols.ubuntu.20.04-arm64." .. recipe.Version .. "." .. recipe.Revision .. ".0-open.nupkg"

    if component == "metapackage"
    and not filesystem.Exists(nugetCache .. metapackage) then
        cmake.Copy(files .. "/nuget/" .. "metapackage.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        nuget.Pack(out .. "metapackage.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "sources"
    and not filesystem.Exists(nugetCache .. sources) then
        local sourcePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. ".zip"
        sevenZip.UnpackArchive(sourceCache .. sourcePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "sources.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        cmake.Rename(out .. "README", out .. "README.orig")
        cmake.Rename(out .. "COPYRIGHT", out .. "COPYRIGHT.orig")
        nuget.Pack(out .. "sources.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "binaries.win-x86"
    and not filesystem.Exists(nugetCache .. runtimesWinX86) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            triplet.RuntimeID .. ".Release.zip"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "binaries.win-x86.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        nuget.Pack(out .. "binaries.win-x86.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "binaries.win-x64"
    and not filesystem.Exists(nugetCache .. runtimesWinX64) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            triplet.RuntimeID .. ".Release.zip"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "binaries.win-x64.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        nuget.Pack(out .. "binaries.win-x64.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "symbols.win-x86"
    and not filesystem.Exists(nugetCache .. symbolsWinX86) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            triplet.RuntimeID .. ".Release.zip"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "symbols.win-x86.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        nuget.Pack(out .. "symbols.win-x86.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "symbols.win-x64"
    and not filesystem.Exists(nugetCache .. symbolsWinX64) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            triplet.RuntimeID .. ".Release.zip"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "symbols.win-x64.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        nuget.Pack(out .. "symbols.win-x64.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "binaries.ubuntu.20.04-x86"
    and not filesystem.Exists(nugetCache .. runtimesUbuntu2004X86) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            "ubuntu.20.04-x86" .. ".Release.tar"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "binaries.ubuntu.20.04-x86.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        cmake.Copy(files .. "/res/" .. "symlinks.sh", out .. "lib")
        filesystem.DeleteFile(out .. "lib/libluajit.so")
        filesystem.DeleteFile(out .. "lib/libluajit.so.2")
        nuget.Pack(out .. "binaries.ubuntu.20.04-x86.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "binaries.ubuntu.20.04-x64"
    and not filesystem.Exists(nugetCache .. runtimesUbuntu2004X64) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            "ubuntu.20.04-x64" .. ".Release.tar"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "binaries.ubuntu.20.04-x64.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        cmake.Copy(files .. "/res/" .. "symlinks.sh", out .. "lib")
        filesystem.DeleteFile(out .. "lib/libluajit.so")
        filesystem.DeleteFile(out .. "lib/libluajit.so.2")
        nuget.Pack(out .. "binaries.ubuntu.20.04-x64.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "binaries.ubuntu.20.04-arm64"
    and not filesystem.Exists(nugetCache .. runtimesUbuntu2004Arm64) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            "ubuntu.20.04-arm64" .. ".Release.tar"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "binaries.ubuntu.20.04-arm64.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        cmake.Copy(files .. "/res/" .. "symlinks.sh", out .. "lib")
        filesystem.DeleteFile(out .. "lib/libluajit.so")
        filesystem.DeleteFile(out .. "lib/libluajit.so.2")
        nuget.Pack(out .. "binaries.ubuntu.20.04-arm64.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "symbols.ubuntu.20.04-x86"
    and not filesystem.Exists(nugetCache .. symbolsUbuntu2004X86) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            "ubuntu.20.04-x86" .. ".Release.tar"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "symbols.ubuntu.20.04-x86.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        filesystem.DeleteFile(out .. "lib/libluajit.so")
        filesystem.DeleteFile(out .. "lib/libluajit.so.2")
        nuget.Pack(out .. "symbols.ubuntu.20.04-x86.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "symbols.ubuntu.20.04-x64"
    and not filesystem.Exists(nugetCache .. symbolsUbuntu2004X64) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            "ubuntu.20.04-x64" .. ".Release.tar"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "symbols.ubuntu.20.04-x64.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        filesystem.DeleteFile(out .. "lib/libluajit.so")
        filesystem.DeleteFile(out .. "lib/libluajit.so.2")
        nuget.Pack(out .. "symbols.ubuntu.20.04-x64.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    elseif component == "symbols.ubuntu.20.04-arm64"
    and not filesystem.Exists(nugetCache .. symbolsUbuntu2004Arm64) then
        local cmakePackage =
            recipe.Vendor .. "." .. recipe.Name .. "." ..
            recipe.Modification .. "." .. recipe.Version .. "." ..
            "ubuntu.20.04-arm64" .. ".Release.tar"
        sevenZip.UnpackArchive(binaryCache .. cmakePackage, filesystem.CurrentFolder .. "/" .. out)
        cmake.Copy(files .. "/nuget/" .. "symbols.ubuntu.20.04-arm64.nuspec", out)
        cmake.Copy(files .. "/res/" .. "README.md", out)
        cmake.Copy(files .. "/res/" .. "LICENSE.txt", out)
        filesystem.DeleteFile(out .. "lib/libluajit.so")
        filesystem.DeleteFile(out .. "lib/libluajit.so.2")
        nuget.Pack(out .. "symbols.ubuntu.20.04-arm64.nuspec", nugetCache)
        cmake.DeleteFolder(out)
    end

    console.PrintColor("Making NuGet package done", console.Colors.Green)
end

if options.Target == "source" then
    recipe.MakeSource()
elseif options.Target == "cmake" then
    recipe.MakeCMake()
elseif options.Target == "nuget" then
    recipe.MakeNuGet(options.TargetArgument)
end

return recipe
