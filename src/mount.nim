import box, strutils, os, openBox, httpclient, diff, jsony

proc getRelative*(s: Box): Box = 
    if s.t.startsWith("https://") or s.t.startsWith("https://"):
        # It's in the cloud, fetch it
        var client: HttpClient = newHttpClient()
        return openBox(client.getContent(s.t))
    elif fileExists(s.t):
        # Local file
        return openBox(readFile(s.t))
    else:
        echo "Error when trying to get Relative box (" & s.t & "). It's no longer available locally or online."

proc toRaw*(s: Box): Box = 
    if s.k == raw:
        return s;
    else:
        var rel = toRaw(getRelative(s))
        var cont: string = $(rel.c.toJson()); # Original
        cont = cont.applySteps(s.rc);
        var parsed = cont.fromJson(seq[BoxElement])
        var res = Box(d: s.d, k: raw, f: s.f, t: s.t, c: parsed)
        return res;

proc mountElement(e: BoxElement, path: string) = 
    if not e.d:
        # It's a file
        writeFile(path&e.n, e.fc)
    else:
        # It's a directory
        discard existsOrCreateDir(path&e.n)
        for el in e.dc:
            el.mountElement(path&e.n&"/")

proc mountAt*(s: Box, dir: string) = 
    discard existsOrCreateDir(dir) # Create dir if it does not exist
    var sn = s.toRaw()
    var path = dir;
    if not dir.endsWith("/"):
        path = path & "/";

    for el in sn.c:
        el.mountElement(path)