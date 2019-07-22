# Loria

Minetest 5.0.1+, still WIP. [Craft list](manuals/craft_list.md).

![Ingame screenshot](pictures/screenshot.jpg)

## Requirements

[ngspice shared library](http://ngspice.sourceforge.net/shared.html) (`ngspice.dll` or `libngspice.so` or `libngspice.0.dylib`) in `loria/mods/electricity`:

* Windows pre-compiled library [is here](https://sourceforge.net/projects/ngspice/files/ng-spice-rework/30/ngspice-30_dll_64.zip/download).

* For macOS there is [brew formulae](https://formulae.brew.sh/formula/libngspice).

* For Linux: `./configure --with-ngshared --enable-xspice --enable-cider --enable-openmp --disable-debug && make`.

## Authors

* Bratishka

* Siegmentation Fault
