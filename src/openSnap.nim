## This module loads a SNAP from compressed data
import snap, compression, jsony

proc openSnap*(data: string): Snap = 
    let decompressed = decompress(data);
    let parsed = decompressed.fromJson(Snap)
    return parsed;