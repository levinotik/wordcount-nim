import os, strutils, std/parseopt, memfiles

proc printUsage() =
    const usage = """
NAME
 wc – word, line, character, and byte count
SYNOPSIS
 wc [-clmw] [file ...]

The following options are available:
-c      The number of bytes in each input file is written to the standard output.  This will cancel out any
        prior usage of the -m o
-l      The number of lines in each input file is written to the standard o
-m      The number of characters in each input file is written to the standard output.  If the current locale
        does not support multibyte characters, this is equivalent to the -c option.  This will cancel out any
        prior usage of the -c o
-w      The number of words in each input file is written to the standard output. 
    """
    echo usage

proc countWords*(s: string): int =
    len(s.split(" "))

proc runCommand(parser: OptParser) =
    var 
        helpShowed: bool
        countBytes: bool
        countLines: bool
        countChars: bool
        countWords: bool
        fileName: string
        commandOutput: string
        lineCount: int
    
    for kind, key, val in getOpt():
        case key
        of "h", "help":
            printUsage()
            helpShowed = true
            break
        else: discard
    if not helpShowed:
        for kind, key, val in getOpt():
            case kind
            of cmdArgument:
                fileName = key
                echo "you want me to count using file: ", key
            of cmdLongOption, cmdShortOption:
                case key
                of "w":
                    countWords = true
                of "l":
                    countLines = true
                of "m":
                    countChars = true
                    countBytes = false
                of "c":
                    countBytes = true
                    countChars = false
                else:
                    echo "illegal option --", key
                    break
            else: discard
    if countLines:
        for line in lines(memfiles.open(fileName)):
            inc(lineCount)
    echo lineCount, " ", fileName


when isMainModule:
    var parser = initOptParser(commandLineParams())
    runCommand(parser)
