import diff

type 
    SnapType* = enum
        raw, rel

    SnapElement* = object
        d*: bool 
        n*: string 
        dc*: seq[SnapElement] = @[] 
        fc*: string = "" 

    Snap* = object
        c*: seq[SnapElement] = @[] 
        rc*: seq[Step] = @[] 
        d*: string 
        k*: SnapType 
        f*: bool = false 
        t*: string = "" 