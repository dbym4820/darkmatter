# Darkmatter

![Screen Shot](screenshots/screenshot.png)

## Requirement

* <https://github.com/roswell/roswell>
* Your favorite web browser (Google Chrome, Firefox...)
* libev

## Installation

See also [Installation Guide for Roswell](https://github.com/roswell/roswell/wiki/Installation).

Install the requirements and Roswell.

```
# for macOS
$ brew install libev roswell

# for Ubuntu/Debian
$ apt-get install libev-dev
# and build roswell from source!

# for Arch Linux
$ yaourt -S libev roswell
```

Add the PATH in the initialization file (such as ~/.bashrc) to use `darkm` command later.

```
export PATH=$PATH:~/.roswell/bin
```

Install Darkmatter.

```
$ ros install tamamu/darkmatter
```

## Usage

Darkmatter starts from current directory.

```
# change the current directory to the one starting Darkmatter from
$ cd ~/path/to/root-directory

# start Darkmatter
$ darkm
# Open localhost:8888/browse/file.lisp in your browser!
```

## Symbols

```
*current-directory*
;; The path where the file exists

(enable-infix-syntax)
;; #f(#f(9 + 8 * 2) / 5)

(runtask init-form &body body)
;; Run asynchronous alertable task.
;; The result of body will be alerted finally.

  (checkpoint tmp-form kill-form)
  ;; You can use this form only in runtask.
  ;; If the task should kill, then kill-form will be alerted; otherwise tmp-form will be alerted.
```

## How To Make Plugin

You can regist plugin with config file ($HOME/.darkmatter.conf) to add plugin file paths.  
See [example](https://github.com/tamamu/darkmatter/blob/master/darkmatter.conf.example).

See also examples, [examples/plugtest.lisp](https://github.com/tamamu/darkmatter/blob/master/examples/plugtest.lisp) or [plot.lisp](https://github.com/tamamu/darkmatter/blob/master/src/plot.lisp) and [LispPlot.js](https://github.com/tamamu/darkmatter/blob/master/static/LispPlot.js).

## See Also

* [Clack](https://github.com/fukamachi/clack) - Web application environment for Common Lisp
* [Ace](https://github.com/ajaxorg/ace) - The High Performance Code Editor for the Web
* [marked](https://github.com/chjj/marked) - A markdown parser and compiler
* [KaTeX](https://github.com/Khan/KaTeX) - Fast math typesetting for the web
* [d3](https://github.com/d3/d3) - Data visualizing library for the web
* [Font Awesome](http://fontawesome.io/) - The iconic font and CSS toolkit

## Author

* Eddie (tamamu.1r1s@gmail.com)

## Copyright

Copyright (c) 2017 Eddie (tamamu.1r1s@gmail.com)

## License

Licensed under the MIT License.
