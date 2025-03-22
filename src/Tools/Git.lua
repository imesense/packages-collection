-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "Git"
}

local triplet = _G.Triplet

function module.InitializeRepository(repository)
    local result = console.ExecuteCommand(
        triplet.Commands.Git ..
        " -C " .. repository ..
        " init"
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.CloneRepository(url, destination)
    local result = console.ExecuteCommand(
        triplet.Commands.Git ..
        " clone " ..
        url .. " " ..
        destination
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.CloneRepositoryBranch(url, destination, branch)
    local result = console.ExecuteCommand(
        triplet.Commands.Git ..
        " clone" ..
        " --depth=1" ..
        " --branch " .. branch .. " " ..
        url .. " " ..
        destination
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.AddFiles(repository)
    local result = console.ExecuteCommand(
        triplet.Commands.Git ..
        " -C " .. repository ..
        " add ."
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.CreateCommit(repository, message)
    module.AddFiles(repository)
    local result = console.ExecuteCommand(
        triplet.Commands.Git ..
        " -C " .. repository ..
        " commit -m \"" .. message .. "\""
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.ApplyPatch(repository, patch)
    local result = console.ExecuteCommand(
        triplet.Commands.Git ..
        " -C " .. repository ..
        " am" ..
        " --3way" ..
        " --ignore-whitespace " ..
        patch
    )
    if not result or result == "" then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

return module
