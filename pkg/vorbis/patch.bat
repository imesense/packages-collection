:: Apply patches
cd ..\..
git submodule update "dep/vorbis"
cd dep\vorbis
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\vorbis\0001-Upgrade-vorbis_dynamic-solution-to-Visual-Studio-202.patch
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\vorbis\0002-Add-libogg-reference-from-NuGet.patch
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\vorbis\0003-Update-packages.patch
