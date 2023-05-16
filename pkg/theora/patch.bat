:: Apply patches
cd ..\..\dep\theora
git am --3way --ignore-space-change --keep-cr < ^
    %~dp0\0001-Upgrade-libtheora_dynamic-solution-to-Visual-Studio-.patch
git am --3way --ignore-space-change --keep-cr < ^
    %~dp0\0002-Add-libogg-reference-from-NuGet.patch
git am --3way --ignore-space-change --keep-cr < ^
    %~dp0\0003-Add-libvorbis-reference-from-NuGet.patch
git am --3way --ignore-space-change --keep-cr < ^
    %~dp0\0004-Delete-rint-function-from-encoder.patch
rename README README.md
