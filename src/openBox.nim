import box, compression, jsony

proc openBox*(data: string): Box = 
    let decompressed = decompress(data);
    let parsed = decompressed.fromJson(Box)
    return parsed;