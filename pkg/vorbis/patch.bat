:: Apply patches
cd ..\..\dep\vorbis
git am --3way --ignore-space-change --keep-cr < %~dp0\0001-Upgrade-vorbis_dynamic-solution-to-Visual-Studio-202.patch
git am --3way --ignore-space-change --keep-cr < %~dp0\0002-Add-libogg-reference-from-NuGet.patch
