-- Local imports
local console = require("src.Common.Console")
local filesystem = require("src.Common.Filesystem")

-- Current module
local module = {
    Name = "Binaries"
}

local function ParseArguments()
    local options = {
        Triplet = nil
    }

    local scriptArguments = arg
    for _, scriptArgument in ipairs(scriptArguments) do
        local key, value = scriptArgument:match("^%-%-(%w+)=(.*)$")
        if key then
            if key == "triplet" then
                options.Triplet = value
            else
                io.stderr:write(console.Colors.Yellow .. "Warning: Unknown option \"--" .. key .. "\"\n" .. console.Colors.Default)
            end
        else
            io.stderr:write(console.Colors.Yellow .. "Warning: Invalid argument format. Expected --key=value\n" .. console.Colors.Default)
        end
    end

    if not options.Triplet then
        io.stderr:write(console.Colors.Red .. "Error: --triplet is required\n" .. console.Colors.Default)
        os.exit(1)
    end

    return options
end

function module.PrepareFolders(vendor)
    filesystem.InitializeTree()

    local folders = {
        "cache/Binary/" .. vendor
    }
    for _, path in ipairs(folders) do
        filesystem.CreateFolder(path)
    end
end

local options = ParseArguments()
local triplet = require("src.Triplets." .. options.Triplet)

Options = options
Triplet = triplet

Filesystem = require("src.Common.Filesystem")
Utilities = require("src.Common.Utilities")

Batch = require("src.Tools.Batch")
Git = require("src.Tools.Git")
CMake = require("src.Tools.CMake")
SevenZip = require("src.Tools.SevenZip")

return module
