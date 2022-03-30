import std/[strformat, strutils, parseopt], memfiles, os
const synopsis = "wordcount [-clmw] [file ...]"
proc printUsage() =
    const usage = fmt"""
NAME
 wordcount – word, line, character, and byte count
SYNOPSIS
 {synopsis}

The following options are available:
-c      The number of bytes in each input file is written to the standard output.  This will cancel out any
        prior usage of the -m option.
-l      The number of lines in each input file is written to the standard output.
-m      The number of characters in each input file is written to the standard output.  If the current locale
        does not support multibyte characters, this is equivalent to the -c option.  This will cancel out any
        prior usage of the -c option.
-w      The number of words in each input file is written to the standard output. 
    """
    echo usage

proc countWords*(s: string): int =
    len(s.split({' ', '\t', '\n'}))

proc runCommand(parser: OptParser) =
    var 
        helpShowed, countBytes, countLines, countChars, countWords: bool
        fileName, commandOutput: string
        lineCount, wordCount: int
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
                    let errorMessage = &"illegal option -- {key}\n{synopsis}"
                    quit(errorMessage)
            else: discard
    if countLines:
        for line in lines(memfiles.open(fileName)):
            if countWords:
                inc(wordCount, countWords(line))
            inc(lineCount)
    commandOutput.add("\t")
    if countLines:
        commandOutput.add(intToStr(lineCount))
    if countWords:
        commandOutput.add("\t" & intToStr(wordCount))
    commandOutput.add("\t" & fileName)
    echo commandOutput


when isMainModule:
    var parser = initOptParser(commandLineParams())
    runCommand(parser)
