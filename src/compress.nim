import zippy/ziparchives, std/tables

proc compressFile*(filename: string, content: string): string = 
    var entries: Table[string, string]
    entries[filename] = content
    let archive = createZipArchive(entries)
    return archive;