# Elm-kit
A starter kit for static, elm web-applications. Very much a work in progress.

Assumes elm 0.16 has been installed, and can be found on your path.
If you haven't done that, (then go do that)[http://elm-lang.org/install].

## Usage
Want to install, serve, compile sass, or elm?
Type the following into your terminal (at the root of the repo):
```
make
```

Or, if `make` doesn't work on your machine, try this:
```
npm i --no-progress && elm package install && gulp
```
... which is just the makefile script.

## Tooling:
- gulp for building (does webpack make sense here?)
- elm 0.16
- node-sass for css
- postcss for busywork and minification.
- browserSync for serving and live-reloading (Is there a way to hot-reload outside of reactor?)


## Roadmap:
Set up some kind of deployment.
