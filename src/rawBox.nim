import times, os, box, strutils, pathUtils

proc rawBoxEl(path: string): BoxElement = 
    # detect kind
    if fileExists(path):
        var cont = readFile(path);
        return BoxElement(d: false, n: getFileName(path), fc: cont)
    elif dirExists(path):
        var cont: seq[BoxElement] = @[]
        for kind, pathToEl in walkDir(path):
            cont.add(rawBoxEl(pathToEl))
        return BoxElement(d: true, n: getDirName(path), dc: cont)
    else:
        echo "Raw Box Element not found at " & path

proc rawBoxDir(path: string): Box = 
    var cont: seq[BoxElement] = @[]
    for kind, pathToEl in walkDir(path):
        cont.add(rawBoxEl(pathToEl))
    return Box(k: raw, c: cont, d: ($now()).split("T")[0])

proc rawBoxFile(path: string): Box = 
    return Box(f: true, k:raw, c: @[rawBoxEl(path)], d: ($now()).split("T")[0])

proc rawBox*(path: string): Box = 
    if dirExists(path):
        return rawBoxDir(path)
    elif fileExists(path):
        return rawBoxFile(path)
    else:
        echo "'" & path & "' Not Found"