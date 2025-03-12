rockspec_format = "3.0"

package = "PackagesCollection"
version = "dev-1"

source = {
    url = "git+https://github.com/imesense/packages-collection.git"
}

description = {
    detailed = [[
<div>
    <p>
        <a href="./LICENSE">
            <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License" />
        </a>
    </p>
</div>]],
    homepage = "https://github.com/imesense/packages-collection",
    license = "MIT/X11"
}

dependencies = {
    "lua == 5.1",
    "luafilesystem == 1.8.0-1",
    "luasec == 1.3.2-1",
    "luasocket == 3.1.0-1"
}

build = {
    type = "builtin",

    modules = {
        ["Common.Compression"] = "src\\Common\\Compression.lua",
        ["Common.Console"] = "src\\Common\\Console.lua",
        ["Common.Filesystem"] = "src\\Common\\Filesystem.lua",
        ["Common.Globals"] = "src\\Common\\Globals.lua",
        ["Common.Network"] = "src\\Common\\Network.lua",
        ["Common.Repositories"] = "src\\Common\\Repositories.lua"
    }
}
