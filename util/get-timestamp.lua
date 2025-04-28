-- Local imports
local utilities = require("src.Common.Utilities")

-- Get date from format `yyyy-mm-dd hh:mm:ss`
local date = arg[1]

-- Convert ant print timestamp
print(utilities.GetTimestamp(date))
