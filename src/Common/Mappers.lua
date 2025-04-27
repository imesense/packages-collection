-- Current module
local module = {
    Name = "Mappers"
}

function module.MapWindowsSubsystem(subsystem)
    if not subsystem or subsystem == "" then
        return nil
    end

    local result = ""
    if subsystem == "Desktop" then
        result = ""
    end
    return result
end

function module.MapMacOSPlatform(platform)
    if not platform or platform == "" then
        return nil
    end

    local result = ""
    if platform == "x64" then
        result = "x86_64"
    end
    return result
end

return module
