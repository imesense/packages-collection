# Create folders
Write-Host "Creating folders..."
$folders = @(
    "tmp",
    "cache",
    "cache\Https",
    "bin",
    "share"
)
foreach ($folder in $folders)
{
    if (-not (Test-Path -Path $folder -ErrorAction SilentlyContinue))
    {
        New-Item -Path $folder -ItemType Directory | Out-Null
        Write-Host "$folder created" -ForegroundColor Green
    }
}
Write-Host "Folders created" -ForegroundColor Green

Write-Host ""

function Check-VisualStudio
{
    $installer = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $path = & $installer -latest -property installationPath
    if (-not (Test-Path -Path $path -ErrorAction SilentlyContinue))
    {
        Write-Host "Visual Studio not installed!" -ForegroundColor Red
    }
    else
    {
        Write-Host "Visual Studio installed" -ForegroundColor Green
    }
}

Write-Host "Checking toolchains..."
Check-VisualStudio

Write-Host ""

function Check-Git
{
    if (-not (Get-Command git -ErrorAction SilentlyContinue))
    {
        Write-Host "Git not installed!" -ForegroundColor Red
    }
    else
    {
        Write-Host "Git installed" -ForegroundColor Green
    }
}

function Install-SevenZip
{
    $release = "24.09"
    $source1 = "https://github.com/ip7z/7zip/releases/download/${release}/7zr.exe"
    if (-not (Test-Path -Path cache\Https\7zr-${release}.exe -ErrorAction SilentlyContinue))
    {
        Write-Host "Downloading 7-Zip..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $source1 -OutFile tmp\7zr.exe
        Move-Item -Path tmp\7zr.exe -Destination cache\Https\7zr-${release}.exe
    }

    $source2 = "https://github.com/ip7z/7zip/releases/download/${release}/7z2409-extra.7z "
    if (-not (Test-Path -Path cache\Https\7z2409-extra.7z -ErrorAction SilentlyContinue))
    {
        Invoke-WebRequest -Uri $source2 -OutFile tmp\7z2409-extra.7z
        Move-Item -Path tmp\7z2409-extra.7z -Destination cache\Https\7z2409-extra.7z
    }

    if (-not(Test-Path -Path bin\7za.exe -ErrorAction SilentlyContinue))
    {
        Copy-Item -Path cache\Https\7zr-${release}.exe -Destination tmp\7zr.exe
        Copy-Item -Path cache\Https\7z2409-extra.7z -Destination tmp\7z2409-extra.7z

        Write-Host "Extracting 7-Zip..." -ForegroundColor Yellow
        Push-Location tmp
        & .\7zr.exe x 7z2409-extra.7z -o7z | Out-Null
        Pop-Location

        Move-Item -Path tmp\7z\x64\7za.exe -Destination bin\
        Move-Item -Path tmp\7z\x64\7za.dll -Destination bin\
        Move-Item -Path tmp\7z\x64\7zxa.dll -Destination bin\

        Remove-Item -Path tmp\7z -Recurse
        Remove-Item -Path tmp\7z2409-extra.7z
        Remove-Item -Path tmp\7zr.exe
    }

    Write-Host "7-Zip installed" -ForegroundColor Green
}

function Install-CMake
{
    $release = "3.31.6"
    $architecture = "x86_64"
    $source = "https://github.com/Kitware/CMake/releases/download/v${release}/cmake-${release}-windows-${architecture}.zip"

    if (-not (Test-Path -Path cache\Https\cmake-${release}-windows-${architecture}.zip -ErrorAction SilentlyContinue))
    {
        Write-Host "Downloading CMake..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $source -OutFile tmp\cmake-${release}-windows-${architecture}.zip
        Move-Item -Path tmp\cmake-${release}-windows-${architecture}.zip -Destination cache\Https\cmake-${release}-windows-${architecture}.zip
    }

    if (-not(Test-Path -Path bin\cmake.exe -ErrorAction SilentlyContinue))
    {
        Copy-Item -Path cache\Https\cmake-${release}-windows-${architecture}.zip -Destination tmp/cmake-${release}-windows-${architecture}.zip

        Write-Host "Extracting CMake..." -ForegroundColor Yellow
        & .\bin\7za.exe x tmp\cmake-${release}-windows-${architecture}.zip -otmp | Out-Null

        Move-Item -Path tmp\cmake-${release}-windows-${architecture}\bin\cmake.exe -Destination bin\
        Move-Item -Path tmp\cmake-${release}-windows-${architecture}\bin\cmake-gui.exe -Destination bin\
        Move-Item -Path tmp\cmake-${release}-windows-${architecture}\bin\cmcldeps.exe -Destination bin\
        Move-Item -Path tmp\cmake-${release}-windows-${architecture}\bin\ctest.exe -Destination bin\
        Move-Item -Path tmp\cmake-${release}-windows-${architecture}\bin\cpack.exe -Destination bin\

        Move-Item -Path tmp\cmake-${release}-windows-${architecture}\share\cmake-3.31 -Destination share\

        Remove-Item -Path tmp\cmake-${release}-windows-${architecture} -Recurse
        Remove-Item -Path tmp\cmake-${release}-windows-${architecture}.zip
    }

    Write-Host "CMake installed" -ForegroundColor Green
}

function Install-NuGet
{
    $release = "6.13.2"
    $architecture = "x86"
    $source = "https://dist.nuget.org/win-${architecture}-commandline/v${release}/nuget.exe"

    if (-not (Test-Path -Path cache\Https\nuget-${release}-${architecture}.exe -ErrorAction SilentlyContinue))
    {
        Write-Host "Downloading NuGet..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $source -OutFile tmp\nuget-${release}-${architecture}.exe
        Move-Item -Path tmp\nuget-${release}-${architecture}.exe -Destination cache\Https\nuget-${release}-${architecture}.exe
    }

    if (-not(Test-Path -Path bin\nuget.exe -ErrorAction SilentlyContinue))
    {
        Copy-Item -Path cache\Https\nuget-${release}-${architecture}.exe -Destination bin\nuget.exe
    }

    Write-Host "NuGet installed" -ForegroundColor Green
}

Write-Host "Checking utilities..."
Check-Git
Install-SevenZip
Install-CMake
Install-NuGet
