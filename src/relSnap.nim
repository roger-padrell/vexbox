import times, nudates, os, snap, diff

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

proc relSnapDir(path: string, relSnap: Snap, relSnapPath: string): Snap = 
    var cont: seq[RawSnapElement] = @[]
    for kind, pathToEl in walkDir(path):
        cont.add(rawSnapEl(pathToEl))
    return Snap(c: cont, k:"rel", d: now())

proc relSnapFile(path: string, relSnap: Snap, relSnapPath: string): Snap = 
    let file = readFile(path)
    if relSnap.k == "raw":
        # Relative Snap is raw
        let steps = relDiff(relSnap.c[0].fc, file)
        return Snap(f: true, rc: @[RelSnapElement(fc: steps, d: false)], k: "rel", d: now(), t: relSnapPath)
    
    elif relSnap.k == "rel":
        # Relative Snap is also relative to another Snap
        discard

proc relSnap*(path: string, relSnap: Snap, relSnapPath: string): Snap = 
    if dirExists(path) and not relSnap.f:
        return relSnapDir(path, relSnap, relSnapPath)
    elif fileExists(path) and relSnap.f:
        return relSnapFile(path, relSnap, relSnapPath)
    else:
        echo "'" & path & "' Not Found"