import times, nudates, os, snap

proc rawSnapEl(path: string): RawSnapElement = 
    # detect kind
    if fileExists(path):
        var cont = readFile(path);
        return RawSnapElement(d: false, fc: cont)
    elif dirExists(path):
        var cont: seq[RawSnapElement] = @[]
        for kind, pathToEl in walkDir(path):
            cont.add(rawSnapEl(pathToEl))
        return RawSnapElement(d: true, dc: cont)
    else:
        echo "Raw Snap Element not found at " & path

    

proc rawSnapDir(path: string): Snap = 
    var cont: seq[RawSnapElement] = @[]
    for kind, pathToEl in walkDir(path):
        cont.add(rawSnapEl(pathToEl))
    return Snap(k: "raw", c: cont, d: now())

proc rawSnapFile(path: string): Snap = 
    return Snap(f: true, k:"raw", c: @[rawSnapEl(path)], d: now())

proc rawSnap*(path: string): Snap = 
    if dirExists(path):
        return rawSnapDir(path)
    elif fileExists(path):
        return rawSnapFile(path)
    else:
        echo "'" & path & "' Not Found"