## This file holds the implementation of the "mounting" or "regeneration" of a repository 
## or original element based on a SNAP (object).
## 
## It needs to also mount snaps that the target/current snap uses as a "relative" to, then, make the
## changes in that snap to achieve the final result.
import snap, strutils, os, openSnap, httpclient, diff, jsony

proc getRelative*(s: Snap): Snap = 
    if s.t.startsWith("https://") or s.t.startsWith("https://"):
        # It's in the cloud, fetch it
        var client: HttpClient = newHttpClient()
        return openSnap(client.getContent(s.t))
    elif fileExists(s.t):
        # Local file
        return openSnap(readFile(s.t))
    else:
        echo "Error when trying to get Relative snap (" & s.t & "). It's no longer available locally or online."

proc toRaw*(s: Snap): Snap = 
    if s.k == raw:
        return s;
    else:
        var rel = toRaw(getRelative(s))
        var cont: string = $(rel.c.toJson()); # Original
        cont = cont.applySteps(s.rc);
        var parsed = cont.fromJson(seq[SnapElement])
        var res = Snap(d: s.d, k: raw, f: s.f, t: s.t, c: parsed)
        return res;

proc mountElement(e: SnapElement, path: string) = 
    if not e.d:
        # It's a file
        writeFile(path&e.n, e.fc)
    else:
        # It's a directory
        discard existsOrCreateDir(path&e.n)
        for el in e.dc:
            el.mountElement(path&e.n&"/")

proc mountAt*(s: Snap, dir: string) = 
    discard existsOrCreateDir(dir) # Create dir if it does not exist
    var sn = s.toRaw()
    var path = dir;
    if not dir.endsWith("/"):
        path = path & "/";

    for el in sn.c:
        el.mountElement(path)