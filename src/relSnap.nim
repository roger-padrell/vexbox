import snap, rawSnap, jsony, mount, diff

proc relSnap*(path: string, relSnap: Snap, pathToRelSnap: string): Snap = 
    let thisSnap: Snap = rawSnap(path)
    let thisCont = thisSnap.c.toJson()
    let relCont = toRaw(relSnap).c.toJson()
    let differed = relDiff(relCont, thisCont)
    let res = Snap(rc: differed, d: thisSnap.d, k: rel, f: thisSnap.f, t: pathToRelSnap)
    return res