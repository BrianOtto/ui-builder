# <img src="src/logo.png?raw=true" height="25" width="25" /> UI Builder

UI Builder is a rapid prototyping tool that allows you to create a UI in real-time, by entering simple commands into an online REPL. You can then export your design into a HTML file that embeds a Rebol interpreter **with no outside dependencies**.

You can create full featured apps, powered by Rebol and distributed in a single HTML file!

**Online Demo**

https://brianotto.github.io/ui-builder/web/

<img src="screenshot.png?raw=true" width="1024" />

## Installation

Install a web server and point it to the [web](web) directory.

## Build Instructions

If you make changes to the project then you will need to run the [build script](build.bat) to generate new files in the web directory. This build script only works in Windows right now, but I plan on writing a bash script for Linux / macOS soon.

## Documentation

UI Builder only supports a limited set of elements right now. Documentation will become available as more is added. I will also be adding example templates that can be used as a starting point for your apps.

## 3rd Party Libraries

We make use of the following 3rd party libraries. Please consider donating to these projects, as it helps us all.

[Ren-C](https://github.com/metaeducation/ren-c)

A branch of the open-sourced, Rebol 3 interpreter. This is the magic that allows you to script your apps in Rebol and have two-way communicate with the JavaScript and your UI.

[UIkit](https://github.com/uikit/uikit)

This is the CSS framework that allows your app to be mobile ready and have a modern, lightweight UI.


[Font Awesome](https://github.com/FortAwesome/Font-Awesome)

This is the toolkit that provides the icons for your apps.
