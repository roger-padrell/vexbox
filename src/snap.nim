import times, diff

type 
    RawSnapElement* = object
        d*: bool # Is Directory
        dc*: seq[RawSnapElement] = @[] # Directory content
        fc*: string = "" # File content

    RelSnapElement* = object
        d*: bool # Is Directory
        dc*: seq[RelSnapElement] = @[] # Directory content
        fc*: seq[Step] = @[] # File content

    Snap* = object
        c*: seq[RawSnapElement] = @[] # Raw content
        rc*: seq[RelSnapElement] = @[] # Relative content
        d*: DateTime # Creation date
        k*: string # Type (raw, rel)
        f*: bool = false # Single-file snap
        t*: string = "" # Relative to