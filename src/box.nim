import diff

type 
    BoxType* = enum
        raw, rel

    BoxElement* = object
        d*: bool 
        n*: string 
        dc*: seq[BoxElement] = @[] 
        fc*: string = "" 

    Box* = object
        c*: seq[BoxElement] = @[] 
        rc*: seq[Step] = @[] 
        d*: string 
        k*: BoxType 
        f*: bool = false 
        t*: string = "" 