:: Apply patches
cd ..\..\dep\ogg
git am --3way --ignore-space-change --keep-cr < %~dp0\0001-Upgrade-libogg-solution-to-Visual-Studio-2022.patch
