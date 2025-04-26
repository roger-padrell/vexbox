import diff

type 
    BoxType* = enum
        raw, rel

    BoxElement* = object
        d*: bool # Directory ?
        n*: string # Name
        dc*: seq[BoxElement] = @[]  # Dir content
        fc*: string = "" # File content

    Box* = object
        c*: seq[BoxElement] = @[] # Raw content
        rc*: seq[Step] = @[] # Relative content
        d*: string # Date of creation yyyy-mm-dd
        k*: BoxType # Kind
        f*: bool = false  # Single-file
        t*: string = "" # Relative to
