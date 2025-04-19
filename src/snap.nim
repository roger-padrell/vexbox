import diff

type 
    SnapType* = enum
        raw, rel

    SnapElement* = object
        d*: bool ## Is Directory
        n*: string ## Name
        dc*: seq[SnapElement] = @[] ## Directory content
        fc*: string = "" ## File content

    Snap* = object
        c*: seq[SnapElement] = @[] ## Raw content
        rc*: seq[Step] = @[] ## Relative content
        d*: string ## Creation date (yyyy-mm-dd)
        k*: SnapType ## Type (raw, rel)
        f*: bool = false ## Single-file snap
        t*: string = "" ## Path to snap used as relative