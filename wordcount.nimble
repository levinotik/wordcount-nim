mode = ScriptMode.Verbose

version       = "0.0.1"
author        = "Levi Notik"
description   = "wc in Nim"
license       = "MIT"
bin = @["wordcount"]
srcDir = "wordcount"
requires "nim >= 0.19.4"
requires "unittest2"