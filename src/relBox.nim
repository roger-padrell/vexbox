import box, rawBox, jsony, mount, diff

proc relBox*(path: string, relBox: Box, pathToRelBox: string): Box = 
    let thisBox: Box = rawBox(path)
    let thisCont = thisBox.c.toJson()
    let relCont = toRaw(relBox).c.toJson()
    let differed = relDiff(relCont, thisCont)
    let res = Box(rc: differed, d: thisBox.d, k: rel, f: thisBox.f, t: pathToRelBox)
    return res