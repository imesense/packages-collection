:: Apply patches
cd ..\..
git submodule update "dep/theora"
cd dep\theora
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\theora\0001-Upgrade-libtheora_dynamic-solution-to-Visual-Studio-.patch
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\theora\0002-Add-libogg-reference-from-NuGet.patch
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\theora\0003-Add-libvorbis-reference-from-NuGet.patch
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\theora\0004-Delete-rint-function-from-encoder.patch
git am --3way --ignore-space-change --keep-cr < ..\..\pkg\theora\0005-Update-packages.patch
rename README README.md
