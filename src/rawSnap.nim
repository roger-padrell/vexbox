
import times, os, snap, strutils, pathUtils

proc rawSnapEl(path: string): SnapElement = 
    # detect kind
    if fileExists(path):
        var cont = readFile(path);
        return SnapElement(d: false, n: getFileName(path), fc: cont)
    elif dirExists(path):
        var cont: seq[SnapElement] = @[]
        for kind, pathToEl in walkDir(path):
            cont.add(rawSnapEl(pathToEl))
        return SnapElement(d: true, n: getDirName(path), dc: cont)
    else:
        echo "Raw Snap Element not found at " & path

proc rawSnapDir(path: string): Snap = 
    var cont: seq[SnapElement] = @[]
    for kind, pathToEl in walkDir(path):
        cont.add(rawSnapEl(pathToEl))
    return Snap(k: raw, c: cont, d: ($now()).split("T")[0])

proc rawSnapFile(path: string): Snap = 
    return Snap(f: true, k:raw, c: @[rawSnapEl(path)], d: ($now()).split("T")[0])

proc rawSnap*(path: string): Snap = 
    if dirExists(path):
        return rawSnapDir(path)
    elif fileExists(path):
        return rawSnapFile(path)
    else:
        echo "'" & path & "' Not Found"