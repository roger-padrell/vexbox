import os, strutils, rawSnap, snap, compression, jsony, openSnap, mount

# Raw snap creation
proc createRawSnap*(filePath: string, targetPath: string = filePath&".snap") = 
    let snapel: Snap = rawSnap(filePath)
    let jsonobj = snapel.toJson()
    let jsonstr: string = $jsonobj
    writeFile(targetPath,compress(jsonstr))

# CLI if isMainModule
var arguments: seq[string] = @[]
proc red(msg: string, error=true) = 
    echo "\e[31m"&msg&"\e[0m";
    if error:
        quit(1)
proc green(msg: string) = 
    echo "\e[32m" & msg & "\e[0m";
proc getArgumentFromN(i: int, default:string="ERROR"):string = 
    if arguments.len >= (i+1):
        let arg = arguments[i];
        return arg
    elif default == "ERROR":
        red("Error: Some arguments are missing")
        quit()
    else:
        return default
proc getArgumentFromName(name: string, default:string="ERROR"): string = 
    var found = false;
    var el = "";
    for arg in arguments:
        if arg.startsWith("--"&name&":"):
            el = arg.replace("--"&name&":", "")
            found = true;
    if found:
        return el
    elif default == "ERROR":
        red("Error: Some arguments are missing")
        quit()
    else:
        return default
proc cli*() = 
    arguments = commandLineParams()
    proc help() = 
        echo """"Help" is still in development..."""
    var command = ""
    if arguments.len() > 0:
        command = arguments[0]
    else:
        help()
        quit(0)
    if command == "raw":
        let filePath = getArgumentFromN(1)
        let targetPath = getArgumentFromName("o", filePath&".snap")
        green "Generating snap from scratch..."
        createRawSnap(filePath,targetPath)
        green "Snap generated succesfully at " & targetPath
        quit(0)
    if command == "help":
      help()
      quit(0)
    if command == "read":
        let filePath = getArgumentFromN(1)
        let targetPath = getArgumentFromName("o", filePath&".json")
        green "Decompressing snap..."
        writeFile(targetPath, decompress(readFile(filePath)))
        green "Readeable snap content at " & targetPath
        echo "Sizes:"
        let comp = readFile(filePath).len()
        let decomp = readFile(targetPath).len()
        echo "  Compressed: " & $comp
        echo "  Decompressed: " & $decomp
        echo "Compression ratio: " & $int((decomp-comp)/decomp*100) & "%"
    if command == "mount":
        let filePath = getArgumentFromN(1)
        let targetPath = getArgumentFromName("o", filePath.replace(".snap",""))
        echo "Opening and decompressing snap..."
        let opened = openSnap(readFile(filePath))
        echo "Mounting snap..."
        opened.mountAt(targetPath)
        green "Snap mounted at: " & targetPath
    else:
        red "Command does not exist"
        quit(1)
if isMainModule:
  cli()

# Export as if it was a module
export rawSnap, snap