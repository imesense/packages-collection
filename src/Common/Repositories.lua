-- Local imports
local console = require("src.Common.Console")

-- Current module
local module = {
    Name = "Repositories"
}

function module.InitializeRepository(repository)
    console.ExecuteCommand("git -C " .. repository .. " init")
end

function module.CloneRepository(url, destination)
    console.ExecuteCommand("git clone " .. url .. " " .. destination)
end

function module.CloneRepositoryBranch(url, destination, branch)
    console.ExecuteCommand("git clone --depth=1 --branch " .. branch .. " " .. url .. " " .. destination)
end

function module.CreateCommit(repository, message)
    console.ExecuteCommand("git -C " .. repository .. " add .")
    console.ExecuteCommand("git -C " .. repository .. " commit -m \"" .. message .. "\"")
end

function module.ApplyPatch(repository, patch)
    console.ExecuteCommand("git -C " .. repository .. " am --3way --ignore-whitespace " .. patch)
end

return module
