# Package

version       = "0.1.0"
author        = "ysaak-pudim"
description   = "Nim bridge for Pico Family microcontrollers. Built on top of picostdlib."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["micronim"]


# Dependencies

requires "nim >= 2.2.10"
requires "https://github.com/matodye/picostdlib"
