# Timber

I got bored one afternoon and started writing a desktop panel

### What is Timber?

Timber is a Gtk 3 desktop panel. It draws inspiration from Wingpanel and Budgie-panel but aims eventually to be a fully-featured desktop panel in it's own right with a focus on design, performance and functionality. For now, Timber is a personal project that I decided to develop due to the lack of desktop-independent panels for modern Linux desktops. Wingpanel is good, but I've found it to be very dependent on Pantheon's components such as granite. xfce4-panel and mate-panel are functional, but are not graphically appealing and are rather tied to their respective desktop environments. There have been other more niche attempts at similar projects, but most are either discontinued or are crippled with graphical and functional bugs on most systems.

### Building Timber

Timber uses the Meson build system. It's not a commonly used build system, but it suits the needs of the Timber well. Most common distributions will have a version of Meson in their repositories. If you don't, or if your version is too old, get an updated copy here: http://mesonbuild.com/download.html. Sorry for any inconveniences.

Clone the repository:

`git clone git://www.github.com/zesterer/timber && cd timber`

Create a new build directory:

`mkdir build && cd build`

Configure Timber:

`meson ..`

Build Timber:

`ninja-build`

To run Timber, simply run:

`./timber`

### Credits

I've learned from a lot of code whilst making this. Most notably Ikey Doherty of the Evolve OS project, and the one who 
developed Wingpanel, whoever you are. Thanks, I couldn't have even started this project without you.
