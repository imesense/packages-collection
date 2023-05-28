:: Apply patches
cd ..\..
git submodule update "dep/ogg"
cd dep\ogg
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\ogg\0001-Upgrade-libogg-solution-to-Visual-Studio-2022.patch
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\ogg\0002-Fix-export-definitions.patch
