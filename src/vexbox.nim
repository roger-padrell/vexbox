import os, strutils, rawBox, box, compression, jsony, openBox, mount, relBox

# Raw box creation
proc createRawBox*(filePath: string, targetPath: string = filePath&".vexb") = 
    let boxel: Box = rawBox(filePath)
    let jsonobj = boxel.toJson()
    let jsonstr: string = $jsonobj
    writeFile(targetPath,compress(jsonstr))

proc createRelBox*(filePath: string, relativeTo: string, targetPath: string = filePath&".vexb") = 
    let boxel: Box = relBox(filePath, openBox(readFile(relativeTo)), relativeTo)
    let jsonobj = boxel.toJson()
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
        let targetPath = getArgumentFromName("o", filePath&".vexb")
        green "Generating box from scratch..."
        createRawBox(filePath,targetPath)
        green "Box generated succesfully at " & targetPath
        quit(0)
    elif command == "rel":
        let filePath = getArgumentFromN(1)
        let relPath = getArgumentFromN(2)
        let targetPath = getArgumentFromName("o", filePath&".vexb")
        green "Generating box from relative..."
        createRelBox(filePath, relPath, targetPath)
        green "Box generated succesfully at " & targetPath
        quit(0)
    elif command == "help":
      help()
      quit(0)
    elif command == "read":
        let filePath = getArgumentFromN(1)
        let targetPath = getArgumentFromName("o", filePath&".json")
        green "Decompressing box..."
        writeFile(targetPath, decompress(readFile(filePath)))
        green "Readeable box content at " & targetPath
        echo "Sizes:"
        let comp = readFile(filePath).len()
        let decomp = readFile(targetPath).len()
        echo "  Compressed: " & $comp
        echo "  Decompressed: " & $decomp
        echo "Compression ratio: " & $int((decomp-comp)/decomp*100) & "%"
    elif command == "mount":
        let filePath = getArgumentFromN(1)
        let targetPath = getArgumentFromName("o", filePath.replace(".vexb",""))
        echo "Opening and decompressing box..."
        let opened = openBox(readFile(filePath))
        echo "Mounting box..."
        opened.mountAt(targetPath)
        green "Box mounted at: " & targetPath
    else:
        red "Command does not exist"
        quit(1)
if isMainModule:
  cli()

# Export as if it was a module
export rawBox, box, relBox, mount, openBox, compression