## This file holds the implementation of the "mounting" or "regeneration" of a repository 
## or original element based on a SNAP (object).
## 
## It needs to also mount snaps that the target/current snap uses as a "relative" to, then, make the
## changes in that snap to achieve the final result.
import snap, strutils, os, openSnap, httpclient

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

proc getRawSnap*(s: Snap): Snap = 
    if s.k == raw:
        return s;
    else:
        var rel = getRawSnap(getRelative(s))