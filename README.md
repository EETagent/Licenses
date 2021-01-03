<img align="left" width="64" height="64" src="data/icons/com.github.eetagent.Licenses.svg">

<h1 class="rich-diff-level-zero">Licenses</h1>

[![Vala](https://img.shields.io/badge/lang-Vala-purple.svg)](https://gitlab.gnome.org/GNOME/vala)
[![GTK4](https://img.shields.io/badge/GTK-4-brightgreen.svg)](https://www.gtk.org/)

Simple Vala learning project. An application that displays a list of FOSS licenses

![Licenses Screenshot](data/Screenshot.png?raw=true)

## Building

Following dependencies are required to build the application:
* gtk4-devel
* meson
* vala-devel

To compile the application, run:  
    
    meson build
    ninja -C build

To install, use:

    sudo ninja -C build install