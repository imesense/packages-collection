-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "Git",
    Triplet = {}
}

function module.InitializeRepository(repository)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.Git ..
        " -C " .. repository ..
        " init"
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.CloneRepository(url, destination)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.Git ..
        " clone " ..
        url .. " " ..
        destination
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.CloneRepositoryBranch(url, destination, branch)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.Git ..
        " clone" ..
        " --depth=1" ..
        " --branch " .. branch .. " " ..
        url .. " " ..
        destination
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.AddFiles(repository)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.Git ..
        " -C " .. repository ..
        " add " .. repository
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.CreateCommit(repository, message)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.Git ..
        " -C " .. repository ..
        " commit -m \"" .. message .. "\""
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.ApplyPatch(repository, patch)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.Git ..
        " -C " .. repository ..
        " am" ..
        " --3way" ..
        " --ignore-whitespace " ..
        patch
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.ResetCommit(repository, hash)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.Git ..
        " -C " .. repository ..
        " reset" ..
        " --hard " ..
        hash
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

function module.CreateBranch(repository, branch, hash)
    local result = console.ExecuteCommand(
        module.Triplet.Commands.Git ..
        " -C " .. repository ..
        " checkout -b " ..
        branch .. " " ..
        hash
    )
    if not result then
        console.PrintColor("Error: " .. result, console.Colors.Red)
        return nil
    end
    return result
end

return module
