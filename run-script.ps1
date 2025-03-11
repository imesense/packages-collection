# Set environment variables
$env:PATH = ".\bin;$env:PATH"
$env:LUA_PATH = ".\share\lua\5.1\?.lua;.\share\lua\5.1\?\init.lua;.\?.lua;.\?\init.lua"
$env:LUA_CPATH = ".\lib\lua\5.1\?.dll;.\?.dll"

# Check path to script in arguments
if ($args.Count -eq 0)
{
    Write-Host "No script is specified to run" -ForegroundColor Red
    exit 1
}

# Get path to script from arguments
$scriptToRun = $args[0]

# Run script
lua $scriptToRun $args[1..($args.Count - 1)]
